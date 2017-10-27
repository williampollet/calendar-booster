# To be refactored
class Events::CreateHomeTrajectService
  def initialize(events:, user:)
    
  end

  def perform
    @events.each do |event|
      if is_castable?(event)
        create_traject(trigger_event: event)
      end
    end
  end

  private



  def create_traject(trigger_event:)
    @google_event_creator.perform(event_parameters: input_params(trigger_event))
    if event.part_of_the_day == Event::Morning
      # dependency
      Traject.create!(
        start_time: ,
        end_time: ,
        status:,
        summary:,
        user_id: ,
      )
    elsif event.part_of_the_day == Event::Evening
      Traject.create!(

      )
    end
  end

  def input_params
    {
      start_time: ,
      end_time: ,
      status:,
      summary:
      user_id:
    }
  end
end
