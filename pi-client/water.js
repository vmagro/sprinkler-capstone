const chalk = require('chalk');
const avr = require('./avr');
const connector = require('./connector.js');

module.exports = {
	start: function () {
		const config = connector.config;
		for (var i=0; i < 4; i++) {
			setTimeout(avr.setZone.bind(null, i, true), i * config.zoneDuration);
			setTimeout(avr.setZone.bind(null, i, false), i * config.zoneDuration + config.zoneDuration);
		}
	},
	shouldWater: function (precipProb, lastTime) {
		const config = connector.config;
		const elapsed = new Date().getTime() - lastTime;
		console.log(chalk.red('elapsed time: ' + elapsed));
		if (elapsed > config.maxGap) {
			console.log(chalk.blue('past max watering time'));
			return true;
		}
		if (precipProb > config.rainCutoff) {
			console.log(chalk.blue('not watering, too much chance for rain'));
			return false;
		}
		if (Math.abs(elapsed - config.idealGap) <= 24*60*60*1000) {
			console.log(chalk.blue('watering, near ideal gap time'));
			return true;
		}
		console.log(chalk.cyan('no watering conditions met'));
		return false;
	}
};
