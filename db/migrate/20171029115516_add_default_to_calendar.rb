class AddDefaultToCalendar < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :calendar_id, :string, default: "primary"
  end
end
