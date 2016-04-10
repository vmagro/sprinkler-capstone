const Firebase = require('firebase');
const root = new Firebase('https://vivid-fire-6945.firebaseio.com/');

module.exports = {
	onManualControl: function(cb) {
		root.child('manual').on('value', function (snapshot) {
			cb(snapshot.val());
		});
	},
	setManual: function (zone, val) {
		root.child('manual/' + zone).set(val);
	},
	addHistoryEntry: function(zones, duration) {
		root.child('history').push().set({
			zones: zones,
			time: new Date().getTime(),
			duration: duration
		});
	},
	addScheduledEntry: function (time) {
		root.child('schedule').push().setWithPriority(time, Firebase.ServerValue.TIMESTAMP);
	},
	location: function(cb) {
		root.child('location').once('value', function (snapshot) {
			cb(snapshot.val());
		});
	},
	lastTime: function(cb) {
		root.child('history').orderByPriority().limitToFirst(1).once('child_added', function (snapshot) {
			cb(snapshot.val().time);
		});
	},
	config: function (cb) {
		root.child('config').once('value', function (snapshot) {
			cb(snapshot.val());
		});
	}
};
