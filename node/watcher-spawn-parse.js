// watcher-spawn-parse.js
// Uses key Node classes: EventEmitter, Stream, ChildProcess, Buffer.

"use strict";

const 
  fs = require('fs'),
  spawn = require('child_process').spawn,
  filename = process.argv[2];

if (!filename) {
	throw Error("A file to watch must be specified!");
}

fs.watch(filename, function(event) {
	console.log("Event is " + event);
	
	let
	  ls = spawn('ls', ['-lh', filename]),
	  output = '';
	// chunk represents an expected argument to the function. In this case,
	// the arg is a buffer.
	ls.stdout.on('data', function(chunk) {
		// Calling toString() explicitly converts the buffer’s contents to a 
		// JavaScript string using Node’s default encoding (UTF-8). This means
		// copying the content into Node’s heap, which can be a slow operation,
		// relatively speaking. If you can, it’s better to work with buffers 
		// directly, but strings are more convenient.
		output += chunk.toString();
	});

	ls.on('close', function(){
		let parts = output.split(/\s+/);
		console.dir([parts[0], parts[4], parts[8]]);
	})
});
console.log("Now watching " + filename + " for changes...");
