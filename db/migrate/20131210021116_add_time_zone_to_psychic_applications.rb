class AddTimeZoneToPsychicApplications < ActiveRecord::Migration
  def change
    add_column :psychic_applications, :time_zone, :string

    execute <<-SQL
      UPDATE psychic_applications
      SET time_zone = 'Eastern Time (US & Canada)'
      WHERE time_zone IS NULL;
    SQL

    change_column :psychic_applications, :time_zone, :string, null: false
  end
end
