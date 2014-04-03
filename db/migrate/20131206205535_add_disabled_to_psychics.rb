class AddDisabledToPsychics < ActiveRecord::Migration
  def change
    add_column :psychics, :disabled, :boolean
  end
end
