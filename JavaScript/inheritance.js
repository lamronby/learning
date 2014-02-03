
var dump = function(str) {
    document.writeln(str);
}

dump("<h2>Inheritance</h2>");


dump("<h3>Prototypal</h3>");

//-------- Important function, should be reused.
// Create an Object.create function that allows for creating from a prototype.
if (typeof Object.create !== 'function') {
    Object.create = function (o) {
        var F = function () {};	// Constructor
        F.prototype = o;
        return new F();
    };
}


var myMammal = {
	name : 'Herb the Mammel',
	get_name: function() {
		return this.name;
	},
	says : function() {
		return this.saying || '';
	}
};

document.writeln('My mammal\'s name is ' + myMammal.get_name());

// "derived" class
var myCat = Object.create(myMammal);
myCat.name = 'Henrietta';
myCat.saying = 'meow';
myCat.purr = function(n) { 
	var i, s = '';
	for (i = 0; i < n; i += 1) {
		if (s) {
			s += '-';
		}
		s += 'r';
	}
	return s;
}
myCat.get_name = function() {
	return this.says() + ' ' + this.name + ' ' + this.says();
}

document.writeln('My cat says ' + myCat.says()); // 'meow'
document.writeln('My cat purrs like this: ' + myCat.purr(5)); // 'r-r-r-r-r'
document.writeln('My cat\'s name is ' + myCat.get_name( )); // 'meow Henrietta meow'

dump("<h3>Functional</h3>");

// Support private methods.

var mammal = function (spec) {
	var that = {};

	that.get_name = function() {
		return spec.name;
	};

	that.says = function() {
		return spec.saying || '';
	}

	return that;
};


// call with spec that just contains a name
myMammal = mammal({name: 'Chico'});

document.writeln('My mammal\'s name is ' + myMammal.get_name());

// In the pseudoclassical pattern, the Cat constructor function had to 
// duplicate work that was done by the Mammal constructor. That isn’t necessary
// in the functional pattern because the Cat constructor will call the Mammal
// constructor, letting Mammal do most of the work of object creation, so
// Cat only has to concern itself with the differences.

var cat = function (spec) {
	spec.saying = spec.saying || 'meow';
	var that = mammal(spec);

	that.purr = function(n) { 
		var i, s = '';
		for (i = 0; i < n; i += 1) {
			if (s) {
				s += '-';
			}
			s += 'r';
		}
		return s;
	};

	that.get_name = function() {
		return that.says() + ' ' + spec.name + ' ' + that.says();
	};

	return that;
}

myCat = cat({name: 'MouseEater'});

document.writeln('My cat says ' + myCat.says()); // 'meow'
document.writeln('My cat purrs like this: ' + myCat.purr(15)); // 'r-r-r-r-r'
document.writeln('My cat\'s name is ' + myCat.get_name()); // 'meow Henrietta meow'


//-------- Important function, should be reused.
// Allows a new method to be added to any function?
Function.prototype.method = function (name, func) {
    // Add the method only if it doesn't already exist.
    if (!this.prototype[name]) {
        this.prototype[name] = func;
    }
    return this;
}

// A 'superior' method that takes a method name and returns a function that 
// invokes that method. The function will invoke the original method even if
// the property is changed.
Object.method('superior', function (name) {
	var that = this,
		method = that[name];
	return function ( ) {
		return method.apply(that, arguments);
	};
});

// cool cat
var coolcat = function(spec) {
	var that = cat(spec),
		super_get_name = that.superior('get_name');
	that.get_name = function (n) {
		return 'like ' + super_get_name() + ' baby';
	};

	return that;
}

var myCoolCat = coolcat({name: 'Bix'});
document.writeln(myCoolCat.get_name());


