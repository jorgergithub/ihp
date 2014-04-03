class CreateHoroscopes < ActiveRecord::Migration
  def change
    create_table :horoscopes do |t|
      t.date :date
      t.text :aries
      t.text :taurus
      t.text :gemini
      t.text :cancer
      t.text :leo
      t.text :virgo
      t.text :libra
      t.text :scorpio
      t.text :sagittarius
      t.text :capricorn
      t.text :aquarius
      t.text :pisces
      t.text :lovescope
      t.string :friendship_compatibility
      t.string :love_compatibility

      t.timestamps
    end
  end
end
