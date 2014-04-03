class AddAvatarIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :avatar_id, :string
  end
end
