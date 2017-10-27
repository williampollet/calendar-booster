class Event < ApplicationRecord
  Morning = "morning".freeze
  Evening = "evening".freeze
  Day = "day".freeze

  belongs_to :user

  def castable?
    (part_of_the_day == Morning || part_of_the_day == Evening) &&
    (self.summary =~ /#{Traject::MorningTrajectSummary}/) == nil &&
    (self.summary =~ /#{Traject::MorningTrajectSummary}/) == nil &&
    self.status == "confirmed"
  end

  def part_of_the_day
    if self.status == "cancelled" || self.start_time.nil?
      nil
    elsif self.start_time.hour > 5 && (self.start_time.hour + self.start_time.min.fdiv(60)) < 9.5
      Morning
    elsif self.start_time.hour > 19 && self.start_time.hour < 24
      Evening
    else
      Day
    end
  end
end
