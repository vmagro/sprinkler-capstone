const chalk = require('chalk');

module.exports = {
	numZones: 4,
	setZone: function setZone(zone, on) {
		if (on)
			console.log(chalk.green('Zone ' + zone + ' on'));
		else
			console.log(chalk.red('Zone ' + zone + ' off'));
	}
};
