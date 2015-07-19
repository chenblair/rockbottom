var https = require("https");
var mysql  = require("mysql");

var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : 'password',
  database : 'database'
});

connection.connect();

function updateRelated(id, callback) {
	setTimeout(function () {
		connection.query("SELECT body FROM test WHERE id = " + id, function (err, rows, fields) {
			if (err) {
				return callback(err);
			}console.log("https://api.idolondemand.com/1/api/sync/querytextindex/v1?&absolute_max_results=100&indexes=stories&print_fields=id&apikey=6322998c-9619-4719-b589-e5aa06c87679&text=" + encodeURIComponent(rows[0]["body"]));
			https.get("https://api.idolondemand.com/1/api/sync/querytextindex/v1?&absolute_max_results=100&indexes=stories&print_fields=id&apikey=6322998c-9619-4719-b589-e5aa06c87679&text=" + encodeURIComponent(rows[0]["body"]), function (res) {
				var full = "";
				res.on('data', function (data) {
					full += data;
					if (full.length > 1e6) { //~1MB
						// FLOOD ATTACK OR FAULTY CLIENT, NUKE REQUEST
						res.connection.destroy();
					}
				});
				res.on('end', function () {
					console.log(full);
					var ids = "";
					var obj = JSON.parse(full);
					console.log(obj);
					for (var i = 1; i < obj.documents.length; i++) { //skipping first one
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

updateRelated(1, function (result) {
	console.log(result);
	connection.end();
});
