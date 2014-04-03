class AddFavoritePsychicIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :favorite_psychic_id, :integer
  end
end
