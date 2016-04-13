const connector = require('./connector');
const avr = require('./avr');
const weather = require('./weather');
const water = require('./water');
const chalk = require('chalk');

// connector.addHistoryEntry([1,2], 1000);

connector.onManualControl(function (zones) {
	for (var i=0; i < zones.length; i++) {
		avr.setZone(i, zones[i] === 'on', true);
	}
});

for (var i=0; i < 4; i++) {
	avr.setZone(i, false);
}

connector.location(function (loc) {
	console.log('got location ' + JSON.stringify(loc));
	setTimeout(function () {
		console.log('fetching weather');
		weather(loc).then(function (weather) {
			console.log('got weather');
			console.log(weather);
			const precipProb = weather;
			water.shouldWater(precipProb).then(function(data) {
				if (data.shouldWater)
					water.start(data.programKey);
			});
		});
	}, 100);
});
