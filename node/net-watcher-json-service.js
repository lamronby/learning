// net-watcher-json-service.js
"use strict";

const
	fs = require('fs'),
	net = require('net'),
	filename = process.argv[2],
	server = net.createServer(function(connection) {

		// reporting
		console.log("Subscriber connected.");
		connection.write(JSON.stringify({
			type: 'watching',
			file: filename
		}) + '\n');

		// watcher setup
		let watcher = fs.watch(filename, function() {
			connection.write(JSON.stringify({
				type: 'changed',
				file: filename,
				timestamp: Date.now()
			}) + '\n');
		});

		// cleanup
		connection.on('close', function() {
			console.log("Subscriber disconnected.");
			watcher.close();
		});
	});

if (!filename) {
	throw Error("No target filename was specified.");
}

// error handling
server.on('error', function(e) {
	console.log("Event is " + e);
});

server.listen(5433, function() {
	console.log("Listening for subscribers...");
});

