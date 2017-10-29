class Trajects::CalculateDurationService
  def duration(start_location: Traject::DefaultDestination, end_location: Traject::DefaultDestination, departure_time: nil, arrival_time: nil)
    @start_location = start_location
    @end_location = end_location
    (@departure_time = departure_time.to_i) if @departure_time
    (@arrival_time = arrival_time.to_i) if @arrival_time

    # par défaut, un trajet dure 30 min on se dit...
    if @start_location == @end_location
      return 1800
    end

    legs = google_directions_api_response.fetch('routes').first.fetch('legs')
    raise Traject::ErrorMessageIfSeveralLegs if legs.size > 1
    legs.first.fetch("duration").fetch("value")
  end

  private

  def directions_client
    Faraday.new(url: "https://maps.googleapis.com/maps/api/directions/json")
  end

  def google_directions_api_response
    response = directions_client.get do |req|
      req.params['key'] = ENV['MAPS_API_KEY']
      req.params['origin'] = @start_location
      req.params['destination'] = @end_location
      req.params['mode'] = Traject::TravelMode
      req.params['arrival_time'] = @arrival_time
      req.params['departure_time'] = @departure_time
    end
    JSON.parse(response.body)
  end
end
