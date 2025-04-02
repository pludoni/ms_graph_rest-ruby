module MsGraphRest
  class CalendarCancelEvent < ModifyingAction
    Response.example("value" => [], "@odata.context" => "", "@odata.nextLink" => "")

    # Issues getSchedule. If user_id is given, uses the
    #  /users/ID/calendar/getSchedule, otherwise me/calendar/getSchedule endpoint
    # @return Response
    # @param id [String] MSOffice Event ID
    # @param user_id [String] Optional user id that is used for the request
    # @param comment [String] Optional comment
    # @param calendar_id [String] Optional calendar id
    def cancel(id:, user_id: nil, comment: nil, calendar_id: nil)
      # POST /me/events/{id}/cancel
      # POST /users/{id | userPrincipalName}/events/{id}/cancel
      # POST /groups/{id}/events/{id}/cancel
      #
      # POST /me/calendar/events/{id}/cancel
      # POST /users/{id | userPrincipalName}/calendar/events/{id}/cancel
      # POST /groups/{id}/calendar/events/{id}/cancel
      #
      # POST /me/calendars/{id}/events/{id}/cancel
      # POST /users/{id | userPrincipalName}/calendars/{id}/events/{id}/cancel
      #
      # POST /me/calendarGroups/{id}/calendars/{id}/events/{id}/cancel
      # POST /users/{id | userPrincipalName}/calendarGroups/{id}/calendars/{id}/events/{id}/cancel
      path = case [user_id.present?, user_id.present?]
             when [false, true]
               "me/calendars/#{calendar_id}/events/#{id}/cancel"
             when [true, false]
               "users/#{user_id}/events/#{id}/cancel"
             when [true, true]
               "users/#{user_id}/calendars/#{calendar_id}/events/#{id}/cancel"
             else
               "me/events/#{id}/cancel"
             end
      body = { comment: comment }.compact

      client.post(path, body)
    end
  end
end
