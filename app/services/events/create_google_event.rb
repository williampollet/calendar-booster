class Events::CreateGoogleEvent
  def initialize(user:)
    @user = user
    @calendar_service = GoogleCalendarService.new(user: user)
  end

  def perform(event_parameters:)
    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
      summary: 'New event!',

    })
    # add calendar_id to user
    service.insert_event(user.email, event)
  end

  private

  def input_params

  end
end
