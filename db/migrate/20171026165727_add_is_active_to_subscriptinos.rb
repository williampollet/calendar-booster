class AddIsActiveToSubscriptinos < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :is_active, :boolean, default: true
  end
end
