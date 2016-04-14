var connector = require('./connector');
var avr = require('./avr');
var weather = require('./weather');
var water = require('./water');
var chalk = require('chalk');

// connector.addHistoryEntry([1,2], 1000);

connector.onManualControl(function (zones) {
	for (var i=0; i < zones.length; i++) {
		// avr.setZone(i, zones[i] === 'on', true);
	}
});
avr.setZone(0, true);

for (var i=0; i < 4; i++) {
	avr.setZone(i, false);
}

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
