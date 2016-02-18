from google.appengine.ext import ndb
from protorpc import messages


class Installation(ndb.Model):
    location = ndb.GeoPtProperty()
    owner = ndb.UserProperty()

    # maximum time in seconds between watering
    max_time = ndb.IntegerProperty()

    @classmethod
    def query_installations(cls, user):
        return cls.query(cls.owner == user)

    def to_message(self):
        return InstallationMessage(key=self.key.urlsafe(),
                                   latitude=self.location.lat,
                                   longitude=self.location.lon)


class InstallationMessage(messages.Message):
    key = messages.StringField(1)
    latitude = messages.FloatField(2, variant=messages.Variant.DOUBLE)
    longitude = messages.FloatField(3, variant=messages.Variant.DOUBLE)


class InstallationsList(messages.Message):
    installations = messages.MessageField(InstallationMessage, 1, repeated=True)
