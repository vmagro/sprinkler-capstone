const connector = require('./connector');
const avr = require('./avr');
const weather = require('./weather');
const water = require('./water');
const chalk = require('chalk');

// connector.addHistoryEntry([1,2], 1000);

connector.onManualControl(function (zones) {
	for (var i=0; i < zones.length; i++) {
		avr.setZone(i, zones[i] === 'on');
	}
});

connector.location(function (loc) {
	console.log('got location ' + JSON.stringify(loc));
	setInterval(function () {
		weather(loc).then(function (weather) {
			connector.lastTime(function (lastTime) {
				console.log(weather);
				const precipProb = weather;
				if (water.shouldWater(precipProb, lastTime)) {
					water.start();
				}
			});
		});
	}, 10000);
});
