from google.appengine.ext import ndb
from protorpc import messages, message_types

from Installation import Installation


class ScheduleEntry(ndb.Model):
    installation = ndb.KeyProperty(kind=Installation)
    time = ndb.DateTimeProperty()
    manual = ndb.BooleanProperty()

    @classmethod
    def query_schedule(cls, installation_key):
        return cls.query(cls.installation == installation_key).order(cls.time)

    def to_message(self):
        return ScheduleEntryMessage(
                time=self.time,
                manual=self.manual
        )

    @classmethod
    def from_manual_message(cls, message):
        date = message.time
        if date.utcoffset():
            date = (date - date.utcoffset())
        date = date.replace(tzinfo=None)
        return cls(installation=ndb.Key(urlsafe=message.installation_key),
                   time=date,
                   manual=True)


class ScheduleEntryMessage(messages.Message):
    time = message_types.DateTimeField(1)
    manual = messages.BooleanField(2)


class ScheduleMessage(messages.Message):
    schedule = messages.MessageField(ScheduleEntryMessage, 1, repeated=True)


def schedule_entries_to_message(entries):
    entry_messages = [e.to_message() for e in entries]
    return ScheduleMessage(schedule=entry_messages)


class ManualScheduleRequest(messages.Message):
    installation_key = messages.StringField(1)
    time = message_types.DateTimeField(2)
