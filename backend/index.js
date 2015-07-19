var http = require("http");
var url = require("url");
var qs = require("querystring");
var fs = require("fs");
var db = require("./db");

function async(callback) { //not necc here?
	setTimeout(function () {
		callback();
	}, 0);
}

function route(request, response) {
	var parsed = url.parse(request.url, true);
	console.log("Received " + request.method + " request for " + parsed.pathname);
	if (request.method == "POST") {
		var body = "";
		request.on('data', function (data) {
			body += data;
			if (body.length > 1e6) { //~1MB
				// FLOOD ATTACK OR FAULTY CLIENT, NUKE REQUEST
				request.connection.destroy();
			}
		});
		request.on('end', function () {
			parsed.query = qs.parse(body);
		});
	}

	response.writeHead(200, {"Content-Type": "text/json"});

	var rest = parsed.pathname.split("/");
	rest.shift();
	while (rest.length > 0) {
		if (rest.shift() == "story") {
			if (rest.length == 0) {
				//return random story id
				db.randomStory(function (out) {
					response.write(out);
					response.end();
				});
			}
			else {
				var id = rest.shift();
				if (id == "new") {
					//create new
					db.newStory(parsed.query.userid, parsed.query.body, parsed.query.rating, function (out) {
						response.write(out);
						response.end();
					});
				}
				else {
					//is id
					if (rest.length == 0) {
						//get story
						db.getStory(id, function (out) {
							response.write(out);
							response.end();
						});
					}
					else {
						var method = rest.shift();
						if (method == "related") {
							db.relatedStory(id, function (out) {
								response.write(out);
								response.end();
							});
						}
						else if (method == "update") {
							db.updateStory(id, parsed.query.userid, parsed.query.body, function (out) {
								response.write(out);
								response.end();
							});
						}
						else if (method == "delete") {
							db.deleteStory(id, parsed.query.userid, function (out) {
								response.write(out);
								response.end();
							});
						}
						else if (method == "worse") {
							db.updateRating(id, parsed.query.comparedToId, 1, function (out) {
								response.write(out);
								response.end();
							});
						}
						else if (method == "notasbad") {
							db.updateRating(id, parsed.query.comparedToId, -1, function (out) {
								response.write(out);
								response.end();
							});
						}
					}
				}
			}
		}
	}
}

http.createServer(route).listen(8888);
console.log("Server started.");
