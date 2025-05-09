require 'camel_snake_struct'
require_relative 'modifying_action'
require_relative 'response'

module MsGraphRest
  class CalendarCreateEvent < ModifyingAction
    Response.example("value" => [], "@odata.context" => "", "@odata.nextLink" => "")

    # Issues getSchedule. If user_id is given, uses the
    #  /users/ID/calendar/getSchedule, otherwise me/calendar/getSchedule endpoint
    # @return Response
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
    # @param show_as [String] busy, tentative
    # @param location [Hash]
    def create(
      subject:,
      body:,
      start_time:,
      end_time:,
      location:,
      attendees:,
      allow_new_time_proposals:,
      user_id: nil,
      calendar_id: nil,
      all_day: false,
      draft: false,
      show_as: 'busy',
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

      path = case [user_id.present?, calendar_id.present?]
             when [true, true]
               "users/#{user_id}/calendars/#{calendar_id}/events"
             when [false, true]
               "me/calendars/#{calendar_id}/events"
             when [true, false]
               "users/#{user_id}/events"
             else
               "me/events"
             end

      Response.new(client.post(path, body))
    end
  end
end
