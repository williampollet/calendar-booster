class Events::CreateGoogleEvent
  def initialize(user:)
    @user = user
    @calendar_service = GoogleCalendarService.new(user: user)
  end

  def perform(event_parameters:)
    event = Google::Apis::CalendarV3::Event.new({
      start: {
        date_time: event_parameters.fetch(:event_start).fetch(:date_time),
        time_zone: event_parameters.fetch(:event_end).fetch(:time_zone)
      },
      end:{
        date_time: event_parameters.fetch(:event_end).fetch(:date_time),
        time_zone: event_parameters.fetch(:event_end).fetch(:time_zone)
      },
      summary: event_parameters.fetch(:summary),
      reminders: event_parameters.fetch(:reminders)
    })
    # add calendar_id to user
    @calendar_service.insert_event(user_email: @user.email, event: event)
  end
end
