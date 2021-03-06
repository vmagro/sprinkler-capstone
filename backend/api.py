import endpoints
from google.appengine.ext import ndb
from protorpc import message_types
from protorpc import messages
from protorpc import remote

from model.Installation import Installation, InstallationMessage, InstallationsList
from model.ScheduleEntry import ScheduleEntry, ScheduleMessage, ScheduleEntryMessage, ManualScheduleRequest, \
    schedule_entries_to_message

package = 'Sprinkler'

allowed_client_ids = [
    '',  # web
    '',  # ios
    endpoints.API_EXPLORER_CLIENT_ID
]

scopes = [
    endpoints.EMAIL_SCOPE
]

KEY_RESOURCE = endpoints.ResourceContainer(
        message_types.VoidMessage,
        key=messages.StringField(1))


@endpoints.api(name='sprinkler', version='v1', allowed_client_ids=allowed_client_ids, scopes=scopes)
class SprinklerApi(remote.Service):
    @endpoints.method(request_message=message_types.VoidMessage, response_message=InstallationsList,
                      name='installation.list', path='installation', http_method='GET')
    def installation_list(self, request):
        current_user = endpoints.get_current_user()
        installations = Installation.query_installations(current_user).fetch(10)
        installation_messages = [i.to_message() for i in installations]
        return InstallationsList(installations=installation_messages)

    @endpoints.method(request_message=InstallationMessage, response_message=InstallationMessage,
                      name='installation.create', path='installation', http_method='POST')
    def installation_create(self, request):
        current_user = endpoints.get_current_user()
        installation = Installation.from_create_message(request, current_user)
        installation.put()
        return installation.to_message()

    @endpoints.method(request_message=KEY_RESOURCE, response_message=InstallationMessage,
                      name='installation.get', path='installation/{key}', http_method='GET')
    def installation_get(self, request):
        try:
            installation = ndb.Key(urlsafe=request.key).get()
            if installation.owner != endpoints.get_current_user():
                raise endpoints.UnauthorizedException()
            return installation.to_message()
        except:
            raise endpoints.NotFoundException()

    @endpoints.method(request_message=KEY_RESOURCE, response_message=InstallationMessage,
                      name='installation.destroy', path='installation/{key}', http_method='DELETE')
    def installation_destroy(self, request):
        try:
            installation = ndb.Key(urlsafe=request.key).get()
            if installation.owner != endpoints.get_current_user():
                raise endpoints.UnauthorizedException()
            message = installation.to_message()
            installation.key.delete()
            return message
        except:
            raise endpoints.NotFoundException()

    @endpoints.method(request_message=KEY_RESOURCE, response_message=ScheduleMessage,
                      name='schedule.get', path='schedule/{key}', http_method='GET')
    def schedule_get(self, request):
        try:
            installation = ndb.Key(urlsafe=request.key).get()
            if installation.owner != endpoints.get_current_user():
                raise endpoints.UnauthorizedException()
            # get schedule
            schedule = ScheduleEntry.query_schedule(installation.key).fetch(10)
            return schedule_entries_to_message(schedule)
        except:
            raise endpoints.NotFoundException()

    @endpoints.method(request_message=ManualScheduleRequest, response_message=ScheduleEntryMessage,
                      name='schedule.manual', path='schedule', http_method='POST')
    def schedule_manual(self, request):
        try:
            installation = ndb.Key(urlsafe=request.installation_key).get()
            if installation.owner != endpoints.get_current_user():
                raise endpoints.UnauthorizedException()

            # add schedule entry
            entry = ScheduleEntry.from_manual_message(request)
            entry.put()
            return entry.to_message()
        except:
            raise endpoints.NotFoundException()


APPLICATION = endpoints.api_server([SprinklerApi])
