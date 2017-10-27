class AddReminderDefaultFalseToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :reminders, :boolean, default: false
  end
end
