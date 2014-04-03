class AddStatusToCallbacks < ActiveRecord::Migration
  def change
    add_column :callbacks, :status, :string, default: "active"

    execute <<-SQL
      UPDATE callbacks SET status = 'active'
      WHERE status IS NULL
    SQL
  end
end
