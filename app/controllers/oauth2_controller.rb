class Oauth2Controller < ApplicationController
  before_action :authenticate_user!

  def redirect
    client = Signet::OAuth2::Client.new(client_options)
    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]

    response = client.fetch_access_token!

    current_user.update!(
      oauth_access_token: response["access_token"],
      oauth_refresh_token: response["refresh_token"],
      expires_in: response["expires_in"],
      oauth_access_token_expiration_date: Time.now + response["expires_in"]
    )

    redirect_to subscriptions_path
  end

  private

  def client_options
    {
      client_id: ENV["GOOGLE_CLIENT_ID"],
      client_secret: ENV["GOOGLE_CLIENT_SECRET"],
      authorization_uri: ENV["GOOGLE_AUTH_URI"],
      token_credential_uri: ENV["GOOGLE_TOKEN_URI"],
      scope: Calendar::GoogleOauthScope,
      redirect_uri: callback_url
    }
  end
end
