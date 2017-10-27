class AddGoogleIdToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :google_id, :string
  end
end
