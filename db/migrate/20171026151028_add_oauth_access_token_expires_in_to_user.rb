class AddOauthAccessTokenExpiresInToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :oauth_access_token_expires_in, :integer
  end
end
