class CreateCallScripts < ActiveRecord::Migration
  def change
    create_table :call_scripts do |t|
      t.string :call_sid
      t.string :next_action
      t.text :params
    end
    add_index :call_scripts, :call_sid
  end
end
