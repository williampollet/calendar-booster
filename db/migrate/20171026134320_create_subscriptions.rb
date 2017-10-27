class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.string :kind
      t.string :google_uuid
      t.string :google_resource_id
      t.string :google_resource_uri
      t.integer :expiration
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
