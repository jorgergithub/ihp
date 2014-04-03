class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :calls, :invoice_id

    add_index :psychics, :user_id

    add_index :cards, :client_id

    add_index :clients, :user_id

    add_index :client_phones, :client_id

    add_index :credits, :client_id
    add_index :credits, [:target_id, :target_type]

    add_index :customer_service_representatives, :user_id

    add_index :reviews, :client_id

    add_index :invoices, :psychic_id
    add_index :invoices, :tier_id

    add_index :options, :question_id

    add_index :questions, :survey_id
    add_index :questions, [:id, :type]

    add_index :orders, :client_id

    add_index :order_items, :order_id
    add_index :order_items, :package_id

    add_index :call_surveys, :call_id
    add_index :call_surveys, :survey_id

    add_index :payments, :invoice_id

    add_index :transactions, :client_id
    add_index :transactions, :order_id
    add_index :transactions, :transaction_id

    add_index :answers, :call_survey_id
    add_index :answers, :question_id
    add_index :answers, :option_id
  end
end
