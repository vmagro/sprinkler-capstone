from google.appengine.ext import ndb
from protorpc import messages


class Installation(ndb.Model):
    location = ndb.GeoPtProperty()
    name = ndb.StringProperty()
    owner = ndb.UserProperty()

    # maximum time in seconds between watering
    max_time = ndb.IntegerProperty()

    @classmethod
    def query_installations(cls, user):
        return cls.query(cls.owner == user)

    def to_message(self):
        return InstallationMessage(key=self.key.urlsafe(),
                                   name=self.name,
                                   latitude=self.location.lat,
                                   longitude=self.location.lon,
                                   max_time=self.max_time)

    @classmethod
    def from_create_message(cls, message, owner):
        return Installation(name=message.name,
                            owner=owner,
                            location=ndb.GeoPt(message.latitude, message.longitude),
                            max_time=message.max_time)


class InstallationMessage(messages.Message):
    key = messages.StringField(1)
    name = messages.StringField(2)
    latitude = messages.FloatField(3, variant=messages.Variant.DOUBLE)
    longitude = messages.FloatField(4, variant=messages.Variant.DOUBLE)
    max_time = messages.IntegerField(5, variant=messages.Variant.INT32)


class InstallationsList(messages.Message):
    installations = messages.MessageField(InstallationMessage, 1, repeated=True)
