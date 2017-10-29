class ActionnableEventsValidator < ActiveModel::Validator
  def validates?(record)
    @event = record
    if record.status == "cancelled"
      record.errors.add(
        :event,
        "the event is cancelled"
      )
      return {ok: false, error: record.errors}
    end
    if record.location == nil
      record.errors.add(
        :event,
        "the location is undefined"
      )
      return {ok: false, error: record.errors}
    end
    unless @event.castable?
      record.errors.add(
        :event,
        "the event is not in the good range: start between #{Event::StartTimeMin} and #{Event::StartTimeMax}h or end between #{Event::EndTimeMin} and #{Event::EndTimeMax}h"
      )
      return {ok: false, error: record.errors}
    end
    unless @event == first_event_of_the_day || @event == last_event_of_the_day
      record.errors.add(:event, "the event is not the first, or the last of the day")
      return {ok: false, error: record.errors}
    end
    {ok: true}
  end

  private

  def first_event_of_the_day
    events_of_the_day.min{|e| e.start_time}
  end

  def last_event_of_the_day
    events_of_the_day.max{|e| e.end_time}
  end

  def events_of_the_day
    date = @event.start_time.to_date
    start_range = date
    end_range = date + 1
    # bad practice, I should use a facade
    Event.where(start_time: start_range..end_range).where.not(end_time: nil)
  end
end
