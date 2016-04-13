const chalk = require('chalk');
const moment = require('moment');
const Q = require('q');
const avr = require('./avr');
const connector = require('./connector.js');

// hold schedule entries here by schedule key from firebase and the last moment that it was executed
var history = {};

module.exports = {
	start: function (programKey) {
		connector.program(programKey, function (program) {
			var startOffset = 0;
			for (var zone=0; zone<program.zones.length; zone++) {
				var localZone = zone;
				var zoneDuration = program.zones[localZone] * 60 * 1000;
				setTimeout(avr.setZone.bind(null, localZone, true), startOffset);
				setTimeout(avr.setZone.bind(null, localZone, false), startOffset + zoneDuration);
				startOffset += zoneDuration;
			}
		});
	},
	shouldWater: function (precipProb, lastTime) {
		var deferred = Q.defer();
		connector.config(function(config) {
			connector.schedule(moment().day(), function(scheduleToday) {
				if (precipProb > config.rainCutoff) {
					console.log(chalk.blue('not watering, too much chance for rain'));
					deferred.resolve(false);
					return;
				}
				// check if its time for any of the scheduled programs today
				var now = moment().hours() * 60 + moment().minutes();
				for (var key in scheduleToday) {
					if (scheduleToday.hasOwnProperty(key)) {
						var start = scheduleToday[key].start;
						start = moment().set({'hour': start / 60, 'minute': start % 60});
						if (moment().isSameOrAfter(start)) {
							console.log('current time after schedule entry today');
							if (!history[key]) {
								console.log('have not executed this schedule yet');
								history[key] = moment();
								deferred.resolve({shouldWater: true, programKey: scheduleToday[key].program});
								return;
							} else {
								console.log('have not executed this schedule yet this week');
								var nextWeek = history[key].add(1, 'w');
								//if a week later, ok to water again
								if (moment().isSameOrAfter(nextWeek)) {
									history[key] = moment();
									deferred.resolve({shouldWater: true, programKey: scheduleToday[key].program});
									return;
								}
							}
						}
					}
				}
				console.log(chalk.cyan('no watering conditions met'));
				deferred.resolve(false);
				return;
			});
		});
		return deferred.promise;
	}
};
