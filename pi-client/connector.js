var moment = require('moment');
var Firebase = require('firebase');
var root = new Firebase('https://vivid-fire-6945.firebaseio.com/');

root.child('.info/connected').on('value', function(connectedSnap) {
	if (connectedSnap.val() === true) {
		/* we're connected! */
		console.log('FIREBASE CONNECTED');
	} else {
		/* we're disconnected! */
		console.log('FIREBASE DISCONNECTED');
	}
});

module.exports = {
	onManualControl: function(cb) {
		console.log('listening for manual controls');
		root.child('manual').on('value', function (snapshot) {
			console.log('manual update');
			cb(snapshot.val());
		});
	},
	setManual: function (zone, val) {
		root.child('manual/' + zone).set(val);
	},
	addHistoryEntry: function(zones, duration) {
		root.child('history').push().setWithPriority({
			zones: zones,
			time: new Date().getTime(),
			timeString: moment(new Date()).format('dddd hA'),
			duration: duration
		}, Firebase.ServerValue.TIMESTAMP);
	},
	addScheduledEntry: function (time) {
		root.child('schedule').push().setWithPriority({
			time: time,
			timeString: moment(time).format('dddd hA'),
		}, Firebase.ServerValue.TIMESTAMP);
	},
	location: function(cb) {
		root.child('location').once('value', function (snapshot) {
			cb(snapshot.val());
		});
	},
	config: function (cb) {
		root.child('config').once('value', function (snapshot) {
			cb(snapshot.val());
		});
	},
	schedule: function (day, cb) {
		root.child('schedule').child(day).once('value', function (snapshot) {
			const schedule = snapshot.val();
			cb(schedule);
		});
	},
	program: function (key, cb) {
		root.child('programs').child(key).once('value', function (snapshot) {
			cb(snapshot.val());
		});
	}
};
