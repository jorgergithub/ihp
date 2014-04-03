class AddStatusToPsychics < ActiveRecord::Migration
  def change
    add_column :psychics, :status, :string, null: false, default: "unavailable"
  end
end
