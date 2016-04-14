var Forecast = require('forecast');
var Q = require('q');

var forecast = new Forecast({
	service: 'forecast.io',
	key: 'f3f308c35f7867d468ac58443ef544be',
	units: 'f', // Only the first letter is parsed 
	cache: true,      // Cache API requests? 
	ttl: {            // How long to cache requests. Uses syntax from moment.js: http://momentjs.com/docs/#/durations/creating/ 
		minutes: 27,
		seconds: 45
	}
});

module.exports = function weather(location) {
	var deferred = Q.defer();
	forecast.get([location.lat, location.lng], function (err, weather) {
		if (err) {
			deferred.reject(err);
			return;
		}
		var daily = weather.daily;
		var totalProbability = 0.0;
		for (var i=0; i < daily.data.length; i++) {
			totalProbability += daily.data[i].precipProbability;
		}
		var probability = totalProbability / daily.data.length;
		deferred.resolve(probability);
	});
	return deferred.promise;
};
