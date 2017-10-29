# to refacto the default location if the overall service works
class Trajects::CreateTrajectService
  def initialize(user:)
    @google_event_creator = Events::CreateGoogleEvent.new(user: user)
    @traject_duration_calculator = Trajects::CalculateDurationService.new
  end

  def perform(trigger_event:)
    @trigger_event = trigger_event
    @google_event_creator.perform(event_parameters: traject_params)
  end

  private

  def traject_params
    {
      event_start: {
        date_time: event_start_time,
        time_zone: Event::DefaultTimezone
      },
      event_end: {
        date_time: event_end_time,
        time_zone: Event::DefaultTimezone
      },
      summary: event_summary,
      reminders: {use_default: false}
    }
  end

  def duration
    @traject_duration_calculator.duration(
      start_location: start_location,
      end_location: end_location,
      departure_time: departure_time,
      arrival_time: arrival_time
    )
  end

  def event_start_time
    @trigger_event.part_of_the_day == Event::Evening ? @trigger_event.end_time.rfc3339 : (@trigger_event.start_time - duration).rfc3339
  end

  def event_end_time
    @trigger_event.part_of_the_day == Event::Evening ? (@trigger_event.end_time + duration).rfc3339 : @trigger_event.start_time.rfc3339
  end

  def event_summary
    @trigger_event.part_of_the_day == Event::Evening ? Traject::EveningTrajectSummary : Traject::MorningTrajectSummary
  end

  def arrival_time
    @trigger_event.start_time if @trigger_event.part_of_the_day == Event::Morning
  end

  def departure_time
    @trigger_event.end_time if @trigger_event.part_of_the_day == Event::Evening
  end

  def start_location
    @trigger_event.part_of_the_day == Event::Evening ? @trigger_event.location : Traject::DefaultDestination
  end

  def end_location
    @trigger_event.part_of_the_day == Event::Morning ? @trigger_event.location : Traject::DefaultDestination
  end
end
