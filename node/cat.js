#!/usr/bin/env node
// --harmony
// cat.js
require('fs').createReadStream(process.argv[2]).pipe(process.stdout);
