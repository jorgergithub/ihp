class RenameClientPhonesPhoneToNumber < ActiveRecord::Migration
  def change
    rename_column :client_phones, :phone, :number
  end
end
