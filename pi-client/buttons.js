var Q = require('q');
var gpio = require('pi-gpio');

// pi pin numbers associated with zone by index in array
var pinNumbers = [16,18,19,22];

for (var i=0; i < pinNumbers.length; i++) {
	gpio.open(pinNumbers[i], 'input', function (err) {
								 console.log('opened pin ' + pinNumbers[i]);
	});
}

function pinPromise(pin) {
	var deferred = Q.defer();
	gpio.read(pin, function (err, val) {
		if (err) {
			deferred.reject(err);
		} else {
			deferred.resolve(val);
		}
	});
	return deferred.promise;
}

module.exports = function () {
	var promises = [];
	for (var i=0; i < pinNumbers.length; i++) {
		promises.push(pinPromise(pinNumbers[i]));
	}
	return Q.all(promises);
};
