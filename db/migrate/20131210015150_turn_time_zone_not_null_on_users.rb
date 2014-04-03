class TurnTimeZoneNotNullOnUsers < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE users
      SET time_zone = 'Eastern Time (US & Canada)'
      WHERE time_zone IS NULL;
    SQL

    change_column :users, :time_zone, :string, null: false
  end
end
