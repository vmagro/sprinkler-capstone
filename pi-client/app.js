const connector = require('./connector');
const avr = require('./avr');
const weather = require('./weather');
const water = require('./water');

avr.setZone(1, true);
connector.addHistoryEntry([1,2], 1000);

connector.onManualControl(function () {
	console.log(arguments);
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
