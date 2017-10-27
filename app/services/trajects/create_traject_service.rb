# to refacto the default location if the overall service works
class Trajects::CreateTrajectService
  def initialize
    @events = events
    @user = user
    @google_event_creator = Events::CreateGoogleEvent.new(user: user)
    @traject_duration_calculator = Trajects::CalculateDurationService.new
  end

  def perform(trigger_event:)
    @trigger_event = trigger_event
  end

  private

  def duration
    @traject_duration_calculator.duration(
      start_location: Traject::DefaultDestination,
      end_location: Traject::DefaultDestination,
      departure_time: departure_time,
      arrival_time: arrival_time
    )
  end

  def arrival_time
    @trigger_event.start_time if @trigger_event.part_of_the_day == Event::Morning
  end

  def departure_time
    @trigger_event.end_time if @trigger_event.part_of_the_day == Event::Evening
  end

  def start_location
    @trigger_event.part_of_the_day == Event::Evening ? @trigger_event.location || Traject::DefaultLocation
  end

  def end_location
    @trigger_event.part_of_the_day == Event::Morning ? @trigger_event.location || Traject::DefaultLocation
  end
end
