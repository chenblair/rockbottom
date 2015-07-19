var http = require("http");
var url = require("url");
var qs = require("querystring");
var fs = require("fs");
function async(callback) { //not necc here?
	setTimeout(function () {
		callback();
	}, 0);
}

function continueRouting(request, parsed, response) {
	response.writeHead(200, {"Content-Type": "text/json"});

	var rest = parsed.pathname.split("/");
	console.log(rest);
	console.log(parsed.query);
	response.write(JSON.stringify({"id":"test"}));
	response.end();
	request.connection.destroy();
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
			continueRouting(request, parsed, response);
		});
	}
	else {
		continueRouting(request, parsed, response);
	}
}

http.createServer(route).listen(8888);
console.log("Server started.");
