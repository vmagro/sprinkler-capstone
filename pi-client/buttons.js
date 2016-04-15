var Q = require('q');
var gpio = require('onoff').Gpio;

// pi pin numbers associated with zone by index in array
var pinNumbers = [23,24,10,25];
var pins = [];
for (var i = 0; i < pinNumbers.length; i++) {
	pins.push(new gpio(pinNumbers[i], 'in', 'falling'));
}

function changeHandler(pin, cb) {
	return function (err, value) {
		cb(pin, value);
	};
}

module.exports = function (cb) {
	for (var i=0; i < pins.length; i++) {
		pins[i].watch(changeHandler(i, cb));
	}
};
