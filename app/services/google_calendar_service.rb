class GoogleCalendarService
  def initialize(user:)
    @user = user
  end

  def unsubscribe(subscription:)
    unsubscriber.post do |req|
        req.url ENV["STOP_NOTIFICATIONS_URL"]
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          "id": subscription.google_uuid,
          "resourceId": subscription.google_resource_id,
        }.to_json
      end
  end

  def subscribe
    response = subscriber.post do |req|
      req.url ENV["SUBSCRIBE_URL"]
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "id": SecureRandom.uuid,
        "type": "web_hook",
        "address": ENV["NOTIFICATION_URL"]
      }.to_json
    end
    JSON.parse(response.body)
  end

  def list_events(user_email:, sync_token:, page_token:)
    service.list_events(
      user_email,
      sync_token: sync_token,
      page_token: page_token
    )
  rescue Google::Apis::AuthorizationError
    refresh_oauth_token
    retry
  end

  def insert_event(user_email:, event:)
    service.insert_event(user_email, event)
  end

  private

  def service
    @service || initialize_service!
  end

  def subscriber
    Faraday.new(url: ENV['GOOGLE_API_URI']) do |conn|
      conn.authorization :Bearer, service.authorization.access_token
      conn.response :logger                  # log requests to STDOUT
      conn.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  rescue Google::Apis::AuthorizationError
    refresh_oauth_token
    retry
  end

  def unsubscriber
    stopper = Faraday.new(url: ENV['GOOGLE_API_URI']) do |conn|
      conn.authorization :Bearer, service.authorization.access_token
      conn.response :logger                  # log requests to STDOUT
      conn.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  rescue Google::Apis::AuthorizationError
    refresh_oauth_token
    retry
  end

  def initialize_service!
   @client = Signet::OAuth2::Client.new(client_options)
   @client.update!(
     access_token: @user.oauth_access_token,
     refresh_token: @user.oauth_refresh_token,
     expires_in: @user.expires_in
   )
   @service = Google::Apis::CalendarV3::CalendarService.new
   @service.authorization = @client
   @service
  end

  def client_options
    {
      client_id: ENV["GOOGLE_CLIENT_ID"],
      client_secret: ENV["GOOGLE_CLIENT_SECRET"],
      authorization_uri: ENV["GOOGLE_AUTH_URI"],
      token_credential_uri: ENV["GOOGLE_TOKEN_URI"],
      scope: Calendar::GoogleOauthScope
    }
  end

  def refresh_oauth_token
    response = @client.refresh!

    @user.update!(
      oauth_access_token: response["access_token"],
      oauth_refresh_token: response["refresh_token"],
      expires_in: response["expires_in"],
      oauth_access_token_expiration_date: Time.now + response["expires_in"]
    )
  end
end
