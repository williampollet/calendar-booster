class SubscribeOnGoogleJob < ApplicationJob
  def call(subscription)

  end

  private

  def subscriber
    Faraday.new(url: ENV['GOOGLE_API_URI']) do |conn|
    conn.authorization :Bearer, @service.authorization.access_token
    conn.response :logger                  # log requests to STDOUT
    conn.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end

  def calendar_service
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = ENV['APPLICATION_NAME']
    service.authorization = authorize
    service
  end
end
