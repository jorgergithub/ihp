class CreateScheduleJobs < ActiveRecord::Migration
  def change
    create_table :schedule_jobs do |t|
      t.string :description, :null => false
      t.string :week_day, :null => false
      t.string :at, :null => false
      t.string :model, :null => false
      t.string :action, :null => false

      t.timestamps
    end
  end
end
