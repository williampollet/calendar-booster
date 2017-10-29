class Event < ApplicationRecord
  Morning = "morning".freeze
  Evening = "evening".freeze
  Day = "day".freeze
  DefaultTimezone = "Europe/Paris"
  StartTimeMin = 5.freeze
  StartTimeMax = 9.5.freeze
  EndTimeMin = 18.freeze
  EndTimeMax = 23.5.freeze

  belongs_to :user

  def castable?
    (part_of_the_day == Morning || part_of_the_day == Evening) &&
    (self.summary != /#{Traject::EveningTrajectSummary}/) &&
    (self.summary != /#{Traject::MorningTrajectSummary}/) &&
    self.status == "confirmed"
  end

  def part_of_the_day
    if self.status == "cancelled" || self.start_time.nil?
      nil
    elsif self.start_time.hour > 5 && (self.start_time.hour + self.start_time.min.fdiv(60)) < 9.5
      Morning
    elsif self.end_time.hour > 18 && self.end_time.hour < 23.5
      Evening
    else
      Day
    end
  end
end
