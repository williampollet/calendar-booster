class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :calendar_id
      t.string :oauth_access_token
      t.string :oauth_refresh_token
      t.string :sync_token
      t.string :name

      t.timestamps
    end
  end
end
