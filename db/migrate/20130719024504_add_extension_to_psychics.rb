class AddExtensionToPsychics < ActiveRecord::Migration
  def change
    add_column :psychics, :extension, :string
  end
end
