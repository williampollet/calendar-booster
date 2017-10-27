class ActionnableEventsValidator < ActiveModel::Validator
  def validate(record)
    @event = record
    unless @event.castable? && (@event == first_event_of_the_day || @event == last_event_of_the_day)
      record.errors.add(:traject, "this record can't be used as a traject trigger")
    end
  end

  def validates?(record)
    validate(record).nil? ? true : false
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
    Event.where(start_time: start_range..end_range)
  end
end
