class CreateDailyFortunes < ActiveRecord::Migration
  def change
    create_table :daily_fortunes do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :sunday, null: false
      t.string :monday, null: false
      t.string :tuesday, null: false
      t.string :wednesday, null: false
      t.string :thursday, null: false
      t.string :friday, null: false
      t.string :saturday, null: false
      t.boolean :active

      t.timestamps
    end
  end
end
