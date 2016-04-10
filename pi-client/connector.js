const Firebase = require('firebase');
const root = new Firebase('https://vivid-fire-6945.firebaseio.com/');

module.exports = {
	onManualControl: function(cb) {
		root.child('manual').on('value', function (snapshot) {
			cb(snapshot.val());
		});
	},
	addHistoryEntry: function(zones, duration) {
		root.child('history').push().set({
			zones: zones,
			time: new Date().getTime(),
			duration: duration
		});
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
	config: {
		maxGap: 5*24*60*60*1000,
		numZones: 4,
		idealGap: 3*24*60*60*1000,
		rainCutoff: 0.5
	}
};
