class MakePsychicExtensionUnique < ActiveRecord::Migration
  def change
    add_index :psychics, :extension, unique: true
  end
end
