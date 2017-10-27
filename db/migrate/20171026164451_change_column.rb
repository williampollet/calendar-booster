class ChangeColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :subscriptions, :expiration, :integer, :limit => 8
  end
end
