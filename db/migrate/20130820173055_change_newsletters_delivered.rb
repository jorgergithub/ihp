class ChangeNewslettersDelivered < ActiveRecord::Migration
  def change
    remove_column :newsletters, :delivered, :boolean
    add_column :newsletters, :delivered_at, :timestamp
  end
end
