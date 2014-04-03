class Horoscope < ActiveRecord::Base
  SIGNS = [ Sign::Aries, Sign::Taurus, Sign::Gemini, Sign::Cancer, Sign::Leo, Sign::Virgo,
            Sign::Libra, Sign::Scorpio, Sign::Sagittarius, Sign::Capricorn, Sign::Aquarius, Sign::Pisces ]

  scope :last_by_date,  lambda { order("date DESC").first }
  scope :last_lovescope_horoscope, lambda { where("lovescope <> ''").last_by_date }

  def signs
    SIGNS.map { |sign| sign.horoscope = self; sign }
  end
end
