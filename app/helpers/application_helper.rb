module ApplicationHelper
  def refresh_oauth
    subscription_google_id = request.headers["HTTP_X_GOOG_CHANNEL_ID"]
    subscription = Subscription.where(google_uuid: subscription_google_id).first
    user = subscription.present? ? subscription.user : current_user
    raise "impossible to find the current user for the application controller" if user.nil?

    if user.oauth_access_token_expiration_date.present? && user.oauth_access_token_expiration_date < Time.now
      client = Signet::OAuth2::Client.new(oauth_client_options)
      response = client.refresh!

      user.update!(
        oauth_access_token: response["access_token"],
        oauth_refresh_token: response["refresh_token"],
        expires_in: response["expires_in"],
        oauth_access_token_expiration_date: Time.now + response["expires_in"]
      )
    end
  end
end
