var chalk = require('chalk');
var Q = require('q');
var SerialPort = require('serialport').SerialPort;
var port = new SerialPort('/dev/ttyUSB0', {
  parser: require('serialport').parsers.readline('\n')
}, false);
var connector = require('./connector');

module.exports = {
  numZones: 4,
  init: function (cb) {
    port.open(function(err) {
      if (err)
        console.log(chalk.red('Failed to open serial'));
      else {
        console.log(chalk.blue('Serial opened'));
        port.on('data', function (data) {
          console.log('Data: ' + data);
        });
        cb();
      }
    });
  },
  setZone: function setZone(zone, on, fromManual) {
    var deferred = Q.defer();
    if (!fromManual) { //prevent infinite loop
      connector.setManual(zone, on ? "on" : "off");
    }
    if (on) {
      console.log(chalk.green('Zone ' + zone + ' on'));
      if (port.isOpen()) {
        port.write(new Buffer([0x42, zone, 0x01]));
        port.drain();
        setTimeout(deferred.resolve, 250);
      } else {
        console.log(chalk.red('serial not open'));
      }
    } else {
      console.log(chalk.red('Zone ' + zone + ' off'));
      if (port.isOpen()) {
        port.write(new Buffer([0x42, zone, 0x00]));
        port.drain();
        setTimeout(deferred.resolve, 250);
      } else {
        console.log(chalk.red('serial not open'));
      }
    }
    return deferred.promise;
  },
};
