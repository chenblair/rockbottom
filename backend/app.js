var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Hello World!');
});

app.route('/story')
	.get(function (req, res) {
		res.send('GET a random story'); //or a specific story, or a story like a specific story
		res.end();
	})
	.post(function (req, res) {
		res.send('POST a new story');
		res.end();
	})
	.put(function (req, res) {
		res.send('PUT an updated version of a story');
		res.end();
	})
	.delete(function (req, res) {
		res.send('DELETE a story');
		res.end();
	})

var server = app.listen(80, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('Example app listening at http://%s:%s', host, port);
});
