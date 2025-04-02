require 'camel_snake_struct'
require_relative 'modifying_action'
require_relative 'response'

module MsGraphRest
  class CalendarUpdateEvent < ModifyingAction
    Response.example("value" => [], "@odata.context" => "", "@odata.nextLink" => "")

    # Issues getSchedule. If user_id is given, uses the
    #  /users/ID/calendar/getSchedule, otherwise me/calendar/getSchedule endpoint
    # @return Response
    # @param id [String] MSOffice Event ID
    # @param start_time [Time] From Date Time
    # @param end_time [Time] To Date Time
    # @param subject [String]
    # @param body [String]
    # @param content_type [String] HTML or TEXT
    # @param user_id [String] Optional user id that is used for the request
    # @param importance [String] normal low high
    # @param all_day [Boolean]
    # @param draft [Boolean]
    # @param allow_new_time_proposals [Boolean]
    # @param attendees [Array]
    # @param location [Hash]
    def create(
      id:,
      subject:,
      body:,
      start_time:,
      end_time:,
      location:,
      attendees:,
      allow_new_time_proposals:,
      user_id: nil,
      calendar_id: nil,
      show_as: 'busy',
      all_day: false,
      draft: false,
      sensitivity: 'normal',
      importance: 'normal',
      content_type: "HTML"
    )
      start_time = start_time.iso8601 if start_time.respond_to?(:iso8601)
      end_time = end_time.iso8601 if end_time.respond_to?(:iso8601)

      body = {
        subject: subject,
        body: {
          content: body,
          contentType: content_type,
        },
        sensitivity: sensitivity,
        importance: importance,
        start: {
          dateTime: start_time,
          timeZone: 'UTC'
        },
        location: location,
        end: {
          dateTime: end_time,
          timeZone: 'UTC'
        },
        isAllDay: all_day,
        showAs: show_as,
        isDraft: draft,
        allowNewTimeProposals: allow_new_time_proposals,
        attendees: attendees,
      }.compact

      # PATCH /me/events/{id}
      # PATCH /users/{id | userPrincipalName}/events/{id}
      # PATCH /groups/{id}/events/{id}
      #
      # PATCH /me/calendar/events/{id}
      # PATCH /users/{id | userPrincipalName}/calendar/events/{id}
      # PATCH /groups/{id}/calendar/events/{id}
      #
      # PATCH /me/calendars/{id}/events/{id}
      # PATCH /users/{id | userPrincipalName}/calendars/{id}/events/{id}
      #
      # PATCH /me/calendarGroups/{id}/calendars/{id}/events/{id}
      # PATCH /users/{id | userPrincipalName}/calendarGroups/{id}/calendars/{id}/events/{id}
      path = case [user_id.present?, calendar_id.present?]
             when [true, true]
               "users/#{user_id}/calendars/#{calendar_id}/events/#{id}"
             when [false, true]
               "me/calendars/#{calendar_id}/events/#{id}"
             when [true, false]
               "users/#{user_id}/events/#{id}"
             else
               "me/events/#{id}"
             end


      Response.new(client.patch(path, body))
    end
  end
end
