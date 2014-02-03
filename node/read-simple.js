// read-simple.js
const
    fs = require('fs'),
    filename = process.argv[2];

if (!filename) {
	throw Error("A file to watch must be specified!");
}

fs.readFile(filename, function (err, data) {
	if (err) {
		throw err;
	}
	console.log(data.toString());
});
