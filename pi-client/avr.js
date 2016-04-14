var chalk = require('chalk');
var SerialPort = require('serialport').SerialPort;
var port = new SerialPort('/dev/ttyAMA0', {}, false);
port.open(function(err) {
	if (err)
		console.log(chalk.red('Failed to open serial'));
	else
		console.log(chalk.blue('Serial opened'));
});
var connector = require('./connector');

module.exports = {
	numZones: 4,
	setZone: function setZone(zone, on, fromManual) {
		if (!fromManual) { //prevent infinite loop
			connector.setManual(zone, on ? "on" : "off");
		}
		if (on) {
			console.log(chalk.green('Zone ' + zone + ' on'));
			if (port.isOpen()) {
				port.write(new Buffer([0xff, zone, 0x01]));
			}
		} else {
			console.log(chalk.red('Zone ' + zone + ' off'));
			if (port.isOpen()) {
				port.write(new Buffer([0xff, zone, 0x00]));
			}
		}
	},
};
