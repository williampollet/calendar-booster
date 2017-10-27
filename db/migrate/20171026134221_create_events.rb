class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :type
      t.string :location
      t.datetime :start_time
      t.datetime :end_time
      t.string :status
      t.string :summary
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
