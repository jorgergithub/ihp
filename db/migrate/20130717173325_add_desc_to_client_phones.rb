class AddDescToClientPhones < ActiveRecord::Migration
  def change
    add_column :client_phones, :desc, :string
  end
end
