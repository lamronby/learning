
var dump = function(str) {
    document.writeln(str);
}

var dump2 = function(str) {
    document.write(str);
    for (i=1; i<arguments.length; i+=1) {
        document.write(arguments[i]);
    }
    document.writeln();
}

// Create an anonymous function.
var add = function(a, b) {
    if (typeof a !== 'number' || typeof b !== 'number') {
        throw {
            name: 'TypeError',
            message: 'add needs numbers'
        };
    }
    return a + b;
};

// Method invocation pattern.    
dump('17 + 29 = ' + add(17,29));

// An object with a method, increment.
var myObject = {
    value: 0,
    increment: function (inc) {
        // Note inc is optional - value is incremented by one if not provided.
        this.value += typeof inc === 'number' ? inc : 1;
        dump('inc = ' + inc + ', value now ' + this.value);
    }
};

dump('Value is currently ' + myObject.value);

myObject.increment(17);

myObject.increment(11);

myObject.increment();

myObject.increment(-5);

myObject.double = function () {
    var that = this;    // Workaround
    
    var helper = function() {
        that.value = add(that.value, that.value);
    };

    // Method invocation pattern.    
    helper();   // Invoke inner function.
};

// Invoke double as a method.
myObject.double();
dump(myObject.value);

// ... and again.
myObject.double();
dump(myObject.value);

dump("<h3>Constructor Invocation Pattern</h3>");

// Create a constructor function that makes an object with a status property.
var Quo = function (string) {
    this.status = string;
};

Quo.prototype.get_status = function() {
    return this.status;
};

// Make an instance of Quo.
var myQuo = new Quo("confused");

dump(myQuo.get_status());

//-------- Example of Apply Invocation Pattern
dump("<h3>Apply Invocation Pattern</h3>");

// Make an array of 2 numbers and add them.

var array = [3, 4];
var sum = add.apply(null, array);

// Make an object with a status memeber.

var statusObject = {
    status: 'A-OK'
};

// statusObject does not inherit from Quo.prototype, but we can invoke the
// get_status method on statusObject even though statusObject does not have
// a get_status method.
var status = Quo.prototype.get_status.apply(statusObject);

dump2('statusObject status=', status);

//-------- Arguments

// Note that defining 'sum' inside of the function does not interfere with the
// 'sum' defined outside the function. The function only sees the inner one.
var sum = function () {
    var i, sum = 0;
    for (i=0; i<arguments.length; i+=1) {
        sum += arguments[i];
    }
    return sum;
}

dump2("After function that parses arguments, sum is ", sum(4, 8, 15, 16, 23, 42));

dump("<h3>Function exception example</h3>");
// Function that throws exception.
var try_it = function() {
    try {
        add("seven");
    } catch (e) {
        dump2(e.name, ": ", e.message);
    }
}

try_it();

dump("<h3>Augmenting Types</h3>");

//-------- Important function, should be reused.
// Allows a new method to be added to any function?
Function.prototype.method = function (name, func) {
    // Add the method only if it doesn't already exist.
    if (!this.prototype[name]) {
        this.prototype[name] = func;
    }
    return this;
}

Number.method('integer', function () {
    return Math[this < 0 ? 'ceil' : 'floor'](this);
})

dump((-10 / 3).integer());  // -3

var hanoi = function (disc, src, aux, dst) {
    if (disc > 0) {
        hanoi(disc - 1, src, dst, aux);
        dump2('Move disc',disc,' from ',src,' to ',dst);
        hanoi(disc - 1, aux, src, dst);
    }
};

hanoi(3, 'Src', 'Aux', 'Dst');

dump("<h2>Recursion</h2>");

// Define a walk_the_DOM function that visits every node of the tree in HTML
// source order, starting from some given node. It invokes a function, passing
// it each node in turn. walk_the_DOM calls itself to process each of the child
// nodes.
var walk_the_DOM = function walk(node, func) {
    func(node);
    node = node.firstChild;
    while (node) {
        walk(node, func);
        node = node.nextSibling;
    }
};

// Define a getElementsByAttribute function. It takes an attribute name string
// and an optional matching value. It calls walk_the_DOM, passing it a function
// that looks for an attribute name in the node. The matching nodes are 
// accumulated in a results array.
var getElementsByAttribute = function (att, value) {
    var results = [];
    walk_the_DOM(document.body, function (node) {
        var actual = node.nodeType === 1 && node.getAttribute(att);
        if (typeof actual === 'string' &&
           (actual === value || typeof value !== 'string')) {
            results.push(node);
        }
    });
    return results;
};

dump("<h2>Closure</h2>");

// Create a quo maker function. It makes an object with a get_status method
// and a private status property.

var quo = function (status) {
    return {
        get_status: function() {
            return status;
        }
    };
};

// Now make an instance of quo

var myQuo = quo("groovy");

dump2("myQuo status=",myQuo.get_status());

// Define a function that sets a DOM node's color
// to yellow and then fades it to white.
var fade = function (node) {
    var level = 1;
    var step = function () {
        var hex = level.toString(16);
        node.style.backgroundColor = '#FFFF' + hex + hex;
        if (level < 15) {
            level += 1;
            setTimeout(step, 100);
        }
    };
    setTimeout(step, 100);
};

fade(document.body);

dump("<h2>Module</h2>");

String.method('deentityify', function ( ) {
    // The entity table. It maps entity names to
    // characters.
    var entity = {
        quot: '"',
        lt: '<',
        gt: '>'
    };

    // Return the deentityify method.
    return function ( ) {
        // This is the deentityify method. It calls the string replace method,
        // looking for substrings that start with '&' and end with ';'. If the
        // characters in between are in the entity table, then replace the
        // entity with the character from the table. It uses
        // a regular expression.
        return this.replace(/&([^&;]+);/g,
            function (a, b) {
                var r = entity[b];
                return typeof r === 'string' ? r : a;
            }
        );
    };
}( ));

document.writeln('&lt;&quot;&gt;'.deentityify( )); // <">


