// write-simple.js
const
    fs = require('fs'),
    filename = process.argv[2];

if (!filename) {
	throw Error("A file to write to must be specified!");
}

fs.writeFile(filename, 'We are eternal all this pain is an illusion.', function (err) {
	if (err) {
		throw err;
	}
	console.log("File saved!");
});
