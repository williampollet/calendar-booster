class ChangeColumnOauthAccessTokenExpiresIn < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :oauth_access_token_expires_in
    add_column :users, :oauth_access_token_expiration_date, :datetime
  end
end
