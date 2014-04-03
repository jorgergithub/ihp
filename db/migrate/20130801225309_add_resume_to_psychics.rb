class AddResumeToPsychics < ActiveRecord::Migration
  def change
    add_column :psychics, :resume, :string
  end
end
