class ChangeNewslettersDeliverBy < ActiveRecord::Migration
  def change
    change_column :newsletters, :deliver_by, :date
  end
end
