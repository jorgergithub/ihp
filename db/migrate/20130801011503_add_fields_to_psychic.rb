class AddFieldsToPsychic < ActiveRecord::Migration
  def change
    add_column :psychics, :address, :string
    add_column :psychics, :city, :string
    add_column :psychics, :state, :string
    add_column :psychics, :zip_code, :string
    add_column :psychics, :landline_number, :string
    add_column :psychics, :cellular_number, :string
    add_column :psychics, :ssn, :string
    add_column :psychics, :date_of_birth, :string
    add_column :psychics, :emergency_contact, :string
    add_column :psychics, :emergency_contact_number, :string
    add_column :psychics, :us_citizen, :boolean
    add_column :psychics, :has_experience, :boolean
    add_column :psychics, :experience, :text
    add_column :psychics, :gift, :string
    add_column :psychics, :explain_gift, :text
    add_column :psychics, :age_discovered, :integer
    add_column :psychics, :reading_style, :text
    add_column :psychics, :why_work, :text
    add_column :psychics, :friends_describe, :text
    add_column :psychics, :strongest_weakest_attributes, :text
    add_column :psychics, :how_to_deal_challenging_client, :text
    add_column :psychics, :tools, :text
    add_column :psychics, :specialties, :text
    add_column :psychics, :professional_goals, :text
    add_column :psychics, :how_did_you_hear, :string
    add_column :psychics, :other, :text
  end
end
