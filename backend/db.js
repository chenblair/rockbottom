var mysql  = require("mysql");

var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : 'password',
  database : 'database'
});

connection.connect();

// connection.query('SELECT * from < table name >', function(err, rows, fields) {
//   if (!err)
//     console.log('The solution is: ', rows);
//   else
//     console.log('Error while performing Query.');
// });

//connection.end();

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
			return callback(JSON.stringify({"id": Number(rows[0]["COUNT(*)"])}));
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
	callback("Related Story ID");
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
