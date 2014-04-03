class AddCallFieldsToClientCalls < ActiveRecord::Migration
  def change
    add_column :client_calls, :parent_call_sid, :string
    add_column :client_calls, :date_created, :string
    add_column :client_calls, :date_updated, :string
    add_column :client_calls, :account_sid, :string
    add_column :client_calls, :to, :string
    add_column :client_calls, :from, :string
    add_column :client_calls, :phone_number_sid, :string
    add_column :client_calls, :status, :string
    add_column :client_calls, :start_time, :string
    add_column :client_calls, :end_time, :string
    add_column :client_calls, :duration, :string
    add_column :client_calls, :price, :string
    add_column :client_calls, :price_unit, :string
    add_column :client_calls, :direction, :string
    add_column :client_calls, :answered_by, :string
    add_column :client_calls, :caller_name, :string
    add_column :client_calls, :uri, :string
  end
end
