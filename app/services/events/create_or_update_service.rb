class Events::CreateOrUpdateService
  def create_or_update(event:, user:)
    if (local_event = ::Event.find_by_google_id(event.id)).present?
      local_event.update!(
        input_params(event, user)
      )
      local_event
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
      google_created_at: event.created,
      reminders: event.reminders ? event.reminders.use_default : nil,
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
