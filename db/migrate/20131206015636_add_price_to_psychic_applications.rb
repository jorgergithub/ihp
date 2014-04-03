class AddPriceToPsychicApplications < ActiveRecord::Migration
  def change
    add_column :psychic_applications, :price, :decimal, precision: 8, scale: 2
  end
end
