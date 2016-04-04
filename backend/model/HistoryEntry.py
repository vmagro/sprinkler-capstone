from google.appengine.ext import ndb


class HistoryEntry(ndb.Model):
    date = ndb.DateTimeProperty()
    type = ndb.StringProperty(choices=['manual', 'weather', 'timer'])

    @classmethod
    def last_watering(cls, installation_key):
        return cls.query(ancestor=installation_key).order(-cls.date).fetch(1)
