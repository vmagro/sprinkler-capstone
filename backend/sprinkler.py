#!/usr/bin/env python
import webapp2


class ScheduleHandler(webapp2.RequestHandler):
    def get(self):
        self.response.write('Hello world!')


app = webapp2.WSGIApplication([
    ('/sprinkler/schedule', ScheduleHandler)
], debug=True)
