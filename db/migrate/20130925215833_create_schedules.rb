class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :psychic_id
      t.date :date
      t.time :start_time
      t.time :end_time
    end
  end
end
