class AddGoogleCreatedAtToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :google_created_at, :datetime
  end
end
