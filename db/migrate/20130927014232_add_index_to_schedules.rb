class AddIndexToSchedules < ActiveRecord::Migration
  def change
    add_index :schedules, :date
    add_index :schedules, [:psychic_id, :date]
  end
end
