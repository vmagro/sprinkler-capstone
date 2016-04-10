const chalk = require('chalk');
const connector = require('./connector');

module.exports = {
	numZones: 4,
	setZone: function setZone(zone, on) {
		connector.setManual(zone, on ? "on" : "off");
		if (on)
			console.log(chalk.green('Zone ' + zone + ' on'));
		else
			console.log(chalk.red('Zone ' + zone + ' off'));
	},
};
