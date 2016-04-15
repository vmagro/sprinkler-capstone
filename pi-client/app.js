var connector = require('./connector');
var avr = require('./avr');
var weather = require('./weather');
var water = require('./water');
var chalk = require('chalk');
var async = require('async');

// connector.addHistoryEntry([1,2], 1000);

connector.onManualControl(function (zones) {
	async.eachSeries([0,1,2,3], function (zone, cb) {
		avr.setZone(zone, zones[zone] === 'on', true).then(cb);
	});
});

/*var on = true;
function loop() {
	avr.setZone(2, on);
	on = !on;
	setTimeout(loop, 1000);
}
loop();*/

async.eachSeries([0,1,2,3], function iteratee(zone, callback) {
	avr.setZone(zone, false).then(callback);
});

var loc = null;

function check() {
	weather(loc).then(function (weather) {
		var precipProb = weather;
		water.shouldWater(precipProb).then(function(data) {
			if (data.shouldWater)
				water.start(data.programKey);
			setTimeout(check, 100);
		});
	});
}

connector.location(function (location) {
	loc = location;
	console.log('got location ' + JSON.stringify(loc));
	check();
});
