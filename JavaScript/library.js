//-------- Important function, should be reused.
// Allows a new method to be added to any function?
Function.prototype.method = function (name, func) {
    // Add the method only if it doesn't already exist.
    if (!this.prototype[name]) {
        this.prototype[name] = func;
    }
    return this;
}


//-------- Important function, should be reused.
// Create an Object.create function that allows for creating from a prototype.
if (typeof Object.create !== 'function') {
    Object.create = function (o) {
        var F = function () {};
        F.prototype = o;
        return new F();
    };
}


var eventuality = function (that) {
	var registry = {};

	that.fire = function (event) {
		// Fire an event on an object. The event can be either a string 
		// containing the name of the event or an object containing a 
		// type property containing the name of the event. Handlers
		// registered by the 'on' method that match the event name
		// will be invoked.

		var array,
			func,
			handler,
			i,
			type = typeof event === 'string' ? event : event.type;

		// If an array of handler exist for this event, then loop through
		// it and execute the handlers in order.

		if (registry.hasOwnProperty(type)) {
			array = registry[type];
			for (i = 0; i < array.length; i += 1) {
				handler = array[i];

				// A handler record contains a method and an optional array
				// of parameters. If the method is a name, look up 
				// the function.
				func = handler.method;
				if (typeof func === 'string') {
					func = this[func];
				}

				// Invoke a handler. If the record contained parameters, then
				// pass them. Otherwise, pass the event objects.

				func.apply(this, handler.parameters || [event]);
			}
		}

		return this;		
	};

	that.on = function (type, method parameters) { 
		// Register an event - make and handler record, put it in a handler
		// array, making one of it doesn't yet exist for this type.

		var handler = {
			method: method,
			parameters: parameters
		};

		if (registry.hasOwnProperty(type)) {
			registry[type].push(handler);
		} else {
			registry[type] = [handler];
		}
		return this;
	};
	return that;
};

