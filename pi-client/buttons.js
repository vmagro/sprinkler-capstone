var Q = require('q');
var gpio = require('onoff').Gpio;

// pi pin numbers associated with zone by index in array
var pinNumbers = [25,10,24,23];
var pins = [];
for (var i = 0; i < pinNumbers.length; i++) {
	pins.push(new gpio(pinNumbers[i], 'in', 'both'));
}

var lastButtonStates = [1,1,1,1];

function update(cb) {
	for (var i=0; i<pins.length; i++) {
		var on = pins[i].readSync();
		if (!on) {
			console.log('waiting for button ' + i + ' to be released');
			while (!pins[i].readSync()) {}
			if (lastButtonStates[i]) {
				cb(i);
			}
			console.log('button ' + i + ' released');
		}
		lastButtonStates[i] = on;
	}
	setTimeout(update.bind(null, cb), 100);
}

module.exports = function (cb) {
	update(cb);
};
