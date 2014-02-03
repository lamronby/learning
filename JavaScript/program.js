var message='Hello, you bright modern wonderful world!';
document.writeln(message + ' ' + message.length);

// New stooge object.
var stooge = {
    "first-name": "Jerome",
    "last-name": "Howard"
};


document.writeln('stooge[\"first-name\"]=' + stooge["first-name"]);

// Try to access a property that does not exist (undefined), use || to 
// set a default value.
document.writeln('stooge[\"middle-name\"]=' + (stooge["middle-name"] || "none"));

//-------- Important function, should be reused.
// Create an Object.create function that allows for creating from a prototype.
if (typeof Object.create !== 'function') {
    Object.create = function (o) {
        var F = function () {};
        F.prototype = o;
        return new F();
    };
}

// Create from stooge prototype.
var another_stooge = Object.create(stooge);
another_stooge['first-name'] = 'Harry';
another_stooge['middle-name'] = 'Moses';
another_stooge.nickname = 'Moe';

document.writeln('another_stooge[\"first-name\"]=' + another_stooge["first-name"]);

// Add a new property to the prototype.
stooge.profession='actor';
document.writeln('another_stooge[\"profession\"]=' + another_stooge["profession"]);

var flight = {
    airline: "Oceanic",
    number: 815,
    departure: {
        IATA: "SYD",
        time: "2004-09-22 14:55",
        city: "Sydney"
    },
    arrival: {
        IATA: "LAX",
        time: "2004-09-23 10:42",
        city: "Los Angeles"
    }
};

document.writeln('flight.arrival.city=' + flight.arrival.city);
document.writeln('flight.arrival=' + flight.arrival.toString());

// for .. in iterator, with type checking
var name;
for (val in flight) {
    if (typeof flight[val] !== 'function' && typeof flight[val] != 'object') {
        document.writeln(val + ': ' + flight[val]);
    }
}

stooge['middle-name'] = 'Lester';
stooge.nickname = 'Curly';
flight.equipment = {
    model: 'Boeing 777'
};
flight.status = 'overdue';

// Allows a new method to be added to any function?
Function.prototype.method = function (name, func) {
    this.prototype[name] = func;
    return this;
}

