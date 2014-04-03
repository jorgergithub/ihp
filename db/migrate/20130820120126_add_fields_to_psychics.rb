class AddFieldsToPsychics < ActiveRecord::Migration
  def change
    add_column :psychics, :ability_clairvoyance, :boolean
    add_column :psychics, :ability_clairaudient, :boolean
    add_column :psychics, :ability_clairsentient, :boolean
    add_column :psychics, :ability_empathy, :boolean
    add_column :psychics, :ability_medium, :boolean
    add_column :psychics, :ability_channeler, :boolean
    add_column :psychics, :ability_dream_analysis, :boolean
    add_column :psychics, :tools_tarot, :boolean
    add_column :psychics, :tools_oracle_cards, :boolean
    add_column :psychics, :tools_runes, :boolean
    add_column :psychics, :tools_crystals, :boolean
    add_column :psychics, :tools_pendulum, :boolean
    add_column :psychics, :tools_numerology, :boolean
    add_column :psychics, :tools_astrology, :boolean
    add_column :psychics, :specialties_love_and_relationships, :boolean
    add_column :psychics, :specialties_career_and_work, :boolean
    add_column :psychics, :specialties_money_and_finance, :boolean
    add_column :psychics, :specialties_lost_objects, :boolean
    add_column :psychics, :specialties_dream_interpretation, :boolean
    add_column :psychics, :specialties_pet_and_animals, :boolean
    add_column :psychics, :specialties_past_lives, :boolean
    add_column :psychics, :specialties_deceased, :boolean
    add_column :psychics, :style_compassionate, :boolean
    add_column :psychics, :style_inspirational, :boolean
    add_column :psychics, :style_straightforward, :boolean
    add_column :psychics, :about, :text
    add_column :psychics, :price, :decimal, precision: 8, scale: 2
  end
end
