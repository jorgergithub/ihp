class MakePhoneNumberUnique < ActiveRecord::Migration
  def change
    add_index :client_phones, :number, unique: true
  end
end
