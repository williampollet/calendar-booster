class Events::CreateOrUpdateService
  def create_or_update(event:, user:)
    if ::Event.find_by_google_id(event.id)
      event = event.update!(
        input_params(event, user)
      )
    else
      event = ::Event.create!(
        input_params(event, user)
      )
    end
  end

  private

  def input_params(event, user)
    {
      location: event.location,
      start_time: event.start ? event.start.date_time : nil,
      end_time: event.end ? event.end.date_time : nil,
      status: event.status,
      user_id: user.id,
      summary: event.summary,
      google_id: event.id,
      type:  type(event.summary)
    }
  end

  def type(summary)
    if summary == ::Traject::EveningTrajectSummary || summary == ::Traject::MorningTrajectSummary
      ::Traject.to_s
    else
      ::StandardEvent.to_s
    end
  end
end
