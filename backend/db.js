var https = require("https");
var mysql  = require("mysql");

var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : 'password',
  database : 'database'
});

connection.connect();

//connection.end();

function updateRelated(id, callback) {
	setTimeout(function () {
		connection.query("SELECT body FROM test WHERE id = " + id, function (err, rows, fields) {
			if (err) {
				return callback(err);
			}
			https.get("https://api.idolondemand.com/1/api/sync/querytextindex/v1?&absolute_max_results=100&indexes=stories&print_fields=id&apikey=6322998c-9619-4719-b589-e5aa06c87679&text=" + encodeURIComponent(rows[0]["body"].replace(/"/g, "")), function (res) {
				var full = "";
				res.on('data', function (data) {
					full += data;
					if (full.length > 1e6) { //~1MB
						// FLOOD ATTACK OR FAULTY CLIENT, NUKE REQUEST
						res.connection.destroy();
					}
				});
				res.on('end', function () {
					var ids = "";
					var obj = JSON.parse(full);
					for (var i = 1; i < obj.documents.length; i++) { //skipping first one
						if (i != 1) ids += ",";
						ids += (obj.documents[i]["id"][0]);
					}
					connection.query("UPDATE test_related SET relatedids = '" + ids + "' WHERE storyid = " + id, function (err, rows, fields) {
						if (err) {
							return callback(err);
						}
						return callback(true);
					});
				});
			}).on("error", function (err) {
				return callback(err);
			});
		})
	},1);
}

function randomStory(callback) {
	connection.query("SELECT COUNT(*) FROM test", function (err, rows, fields) {
		if (err) {
			return callback(JSON.stringify({"error": err}));
		}
		var max = Number(rows[0]["COUNT(*)"]);
		return callback(JSON.stringify({"id": Math.floor(Math.random() * max + 1)}));
	});
	// callback("Random Story ID");
}
function newStory(userid, body, rating, callback) {
	connection.query("INSERT INTO test (userid, body, rating) VALUES ('" + userid + "', '" + body.replace(/'/g, "\\'") + "', " + (rating*10-5) + ")", function (err, rows, fields) {
		if (err) {
			return callback(JSON.stringify({"error": err}));
		}
		connection.query("SELECT COUNT(*) FROM test", function (err, rows, fields) {
			if (err) {
				return callback(JSON.stringify({"error": err}));
			}
			//insert into ondemand
			https.get("https://api.idolondemand.com/1/api/sync/addtotextindex/v1?apikey=6322998c-9619-4719-b589-e5aa06c87679&index=stories&json=" + encodeURIComponent(JSON.stringify({"document":[{"id":Number(rows[0]["COUNT(*)"]),"content":body}]})), function (res) {
				//insert into test_related
				var full = "";
				res.on('data', function (data) {
					full += data;
					if (full.length > 1e6) { //~1MB
						// FLOOD ATTACK OR FAULTY CLIENT, NUKE REQUEST
						res.connection.destroy();
					}
				});
				res.on('end', function () {
					connection.query("INSERT INTO test_related (reference) VALUES ('" + JSON.parse(full)["references"][0]["reference"] + "')", function (err, rows2, fields) {
						if (err) {
							return callback(JSON.stringify({"error": err}));
						}
						updateRelated(Number(rows[0]["COUNT(*)"]), function () {}); //async generate similar
						return callback(JSON.stringify({"id": Number(rows[0]["COUNT(*)"])}));
					});
				});
			}).on("error", function (err) {
				return callback(JSON.stringify({"error": err}));
			});
			// return callback(JSON.stringify({"id": Number(rows[0]["COUNT(*)"])}));
		});
	});
	// callback("New Story ID");
}
function getStory(id, callback) {
	//check shown! check timestamps!
	connection.query("SELECT body FROM test WHERE id = " + id, function (err, rows, fields) {
		if (err) {
			return callback(JSON.stringify({"error": err}));
		}
		return callback(JSON.stringify({"body": rows[0]["body"]}));
	});
	// callback("Story of ID " + id);
}
function relatedStory(id, callback) {
	connection.query("SELECT relatedids FROM test_related WHERE storyid = " + id, function (err, rows, fields) {
		if (err) {
			return callback(JSON.stringify({"error": err}));
		}
		return callback(JSON.stringify({"ids":rows[0]["relatedids"].split(",")}));
	});
	// callback("Related Story ID");
}
function updateStory(id, userid, body, callback) {
	connection.query("SELECT userid FROM test WHERE id = " + id, function (err, rows, fields) {
		if (err) {
			return callback(JSON.stringify({"error": err}));
		}
		if (userid != rows[0]["userid"]) {
			return callback(JSON.stringify({"error": "UNAUTHORIZED"}));
		}
	});
	connection.query("UPDATE test SET body = '" + body.replace(/'/g, "\\'") + "' WHERE id = " + id, function (err, rows, fields) {
		if (err) {
			return callback(JSON.stringify({"error": err}));
		}
		return callback(JSON.stringify({"success": true}));
	});
	// callback("Same Updated Story ID");
}
function deleteStory(id, userid, callback) {
	connection.query("SELECT userid FROM test WHERE id = " + id, function (err, rows, fields) {
		if (err) {
			return callback(JSON.stringify({"error": err}));
		}
		if (userid != rows[0]["userid"]) {
			return callback(JSON.stringify({"error": "UNAUTHORIZED"}));
		}
	});
	connection.query("UPDATE test SET shown = 0 WHERE id = " + id, function (err, rows, fields) {
		if (err) {
			return callback(JSON.stringify({"error": err}));
		}
		return callback(JSON.stringify({"success": true}));
	});
	// callback("Success Boolean");
}

function updateRating(id, comparedToId, posNeg, callback) {
	connection.query("SELECT rating FROM test WHERE id = " + id, function (err, rows, fields) {
		if (err) {
			return callback(JSON.stringify({"error": err}));
		}
		var r = Number(rows[0]["rating"]);
		connection.query("SELECT rating FROM test WHERE id = " + comparedToId, function (err, rows, fields) {
			if (err) {
				return callback(JSON.stringify({"error": err}));
			}
			var s = Number(rows[0]["rating"]);
			if (posNeg > 0 && r < s) {
				//r++, s--: jk not doing anything to s
				r += Math.floor((s-r)/10);
				if (r >= 100) r = 100;
			}
			else if (posNeg < 0 && r > s) {
				//r--, s++: jk not doing anything to s
				r -= Math.floor((r-s)/10);
				if (r <= 0) r = 0;
			}
			connection.query("UPDATE test SET rating = " + r + " WHERE id = " + id, function (err, rows, fields) {
				if (err) {
					return callback(JSON.stringify({"error": err}));
				}
				return callback(JSON.stringify({"success": true}));
			});
		});
	});
}

exports.randomStory = randomStory;
exports.newStory = newStory;
exports.getStory = getStory;
exports.relatedStory = relatedStory;
exports.updateStory = updateStory;
exports.deleteStory = deleteStory;
exports.updateRating = updateRating;
