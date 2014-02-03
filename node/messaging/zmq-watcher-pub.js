// zmq-watcher-pub.js
'use strict';
const
	fs = require('fs'),
	zmq = require('zmq'),

	port = (process.argv[3]) ? process.argv[3] : 5432,

	// create publisher endpoint
	publisher = zmq.socket('pub'),

	filename = process.argv[2];

if (!filename) {
	throw Error("No target filename was specified.");
}


fs.watch(filename, function() {

	console.log("Target file '" + filename + "' changed.");

	//send messsage to any subscribers
	publisher.send(JSON.stringify({
		type: 'changed',
		file: filename,
		timestamp: Date.now()
	}));
});

// listen on TCP port
//publisher.bind('tcp://*:' + port, function(err) {
//	console.log("Listening for zmq subscribers on port " + port + "...");
//});

let endpoint = 'tcp://*:' + port;

// attempt to bind to the specified endpoint;
// this could either fail synchronously by throwing an exception,
// or asynchronously as an argument to the callback.
let attemptBind = function(){
  console.log("Attempting bind on " + endpoint);
  try {
    publisher.bind(endpoint, function(err) {
      if (err) {
        console.log('WARNING: publisher.bind(' + endpoint + ') failed, will retry in a bit. ' + err.message);
        setTimeout(attemptBind, 1000);
      } else {
        console.log('INFO: publisher.bind(' + endpoint + ') succeeded');
      }
    });
  } catch (err) {
    console.log('WARN: publisher.bind(' + endpoint + ') failed, will retry immediately. ' + err.message);
    process.nextTick(attemptBind);
  }
};

// make first attempt to bind this endpoint
attemptBind();


publisher.on('SIGINT', function() {
	console.log("Closing publisher...");
	publisher.close();
})