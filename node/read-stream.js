// read-stream.js
const
	fs = require('fs'),
	stream = fs.createReadStream(process.argv[2]);
stream.on('data', function(chunk) {
	process.stdout.write(chunk);
});
stream.on('error', function(err) {
	// Note using write, console.log, because don't need newline.
	process.stderr.write("ERROR: " + err.message + "\n");
});
