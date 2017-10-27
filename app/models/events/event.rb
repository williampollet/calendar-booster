class Event < ApplicationRecord
  Morning = "morning".freeze
  Evening = "evening".freeze

  belongs_to :user

  def status
    "confirmed"
  end

  def castable?
    (@trigger_event != nil) &&
    (@trigger_event.part_of_the_day == Morning || @trigger_event.part_of_the_day == Evening) &&
    (self.summary =~ Traject::MorningTrajectSummary) == nil &&
    (self.summary =~ Traject::MorningTrajectSummary) == nil
  end
end
