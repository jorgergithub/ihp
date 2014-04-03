class AddTargetToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :target_id, :integer
    add_column :credits, :target_type, :string
  end
end
