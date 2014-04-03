class ChangeHoroscopesFields < ActiveRecord::Migration
  def change
    rename_column :horoscopes, :friendship_compatibility, :friendship_compatibility_from
    add_column :horoscopes, :friendship_compatibility_to, :string

    rename_column :horoscopes, :love_compatibility, :love_compatibility_from
    add_column :horoscopes, :love_compatibility_to, :string
  end
end
