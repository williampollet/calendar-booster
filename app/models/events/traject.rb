class Traject < Event
  MorningTrajectSummary = "[Traject] Home - First meeting".freeze
  EveningTrajectSummary = "[Traject] Last meeting - Home".freeze
  TravelMode = "transit".freeze
  DefaultDestination = ENV['DEFAULTDESTINATION']
end
