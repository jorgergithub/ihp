class ChangeNewslettersDeliverByToDatetime < ActiveRecord::Migration
  def change
    change_column :newsletters, :deliver_by, :datetime
  end
end
