class AddCallIdToHours < ActiveRecord::Migration
  def change
    add_column :hours, :call_id, :integer
    add_index :hours, :call_id
  end
end
