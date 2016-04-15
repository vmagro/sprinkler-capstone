var connector = require('./connector');
var avr = require('./avr');
var weather = require('./weather');
var water = require('./water');
var buttons = require('./buttons');
var chalk = require('chalk');
var async = require('async');

// connector.addHistoryEntry([1,2], 1000);


var currentZoneStates = [false, false, false, false];

connector.onManualControl(function (zones) {
	async.eachSeries([0,1,2,3], function (zone, cb) {
		avr.setZone(zone, zones[zone] === 'on', true).then(cb);
		currentZoneStates[zone] = zones[zone] === 'on';
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

var lastButtonStates = [false, false, false, false];

function check() {
	weather(loc).then(function (weather) {
		// var precipProb = weather;
		// water.shouldWater(precipProb).then(function(data) {
		// 	if (data.shouldWater)
		// 		water.start(data.programKey);
		// 	setTimeout(check, 100);
		// });
	});

	// also check for button presses
	buttons().then(function (buttons) {
		console.log(buttons);
		for (var i=0; i < buttons[i]; i++) {
			if (buttons[i] === 0) {
				if (!lastButtonStates[i]) {
					// this is the first time we saw a push, let's act on it
					avr.setZone(i, !currentZoneStates[i]); //flip zone state
					console.log('pushed button ' + i);
				}
				lastButtonStates[i] = true;
			} else {
				lastButtonStates[i] = false;
			}
		}
	}).catch(function(err) {
		console.log(err);
	});
}

connector.location(function (location) {
	loc = location;
	console.log('got location ' + JSON.stringify(loc));
	check();
});
