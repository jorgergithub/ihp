class Sign
  attr_accessor :horoscope
  attr_reader :name, :index, :first_day, :last_day

  BASIC_YEAR = 2014

  def initialize(name, index, first_day, last_day)
    @name, @index, @first_day, @last_day = name, index, first_day, last_day
  end

  def self.by_date(original_date)
    year = date_before_mar_21?(original_date) ? BASIC_YEAR + 1 : BASIC_YEAR
    date = Date.new(year, original_date.month, original_date.day)

    Horoscope::SIGNS.each do |sign|
      return sign if (date >= sign.first_day && date <= sign.last_day)
    end
  end

  def text
    horoscope.send(name.underscore)
  end

  Aries       = Sign.new("Aries", 0,       Date.new(BASIC_YEAR     ,3,21),  Date.new(BASIC_YEAR    , 4,19))
  Taurus      = Sign.new("Taurus", 1,      Date.new(BASIC_YEAR     ,4,20),  Date.new(BASIC_YEAR    , 5,20))
  Gemini      = Sign.new("Gemini", 2,      Date.new(BASIC_YEAR     ,5,21),  Date.new(BASIC_YEAR    , 6,20))
  Cancer      = Sign.new("Cancer", 3,      Date.new(BASIC_YEAR     ,6,21),  Date.new(BASIC_YEAR    , 7,22))
  Leo         = Sign.new("Leo", 4,         Date.new(BASIC_YEAR     ,7,23),  Date.new(BASIC_YEAR    , 8,22))
  Virgo       = Sign.new("Virgo", 5,       Date.new(BASIC_YEAR     ,8,23),  Date.new(BASIC_YEAR    , 9,22))
  Libra       = Sign.new("Libra", 6,       Date.new(BASIC_YEAR     ,9,23),  Date.new(BASIC_YEAR    , 10,23))
  Scorpio     = Sign.new("Scorpio", 8,     Date.new(BASIC_YEAR     ,10,24), Date.new(BASIC_YEAR    , 11,22))
  Sagittarius = Sign.new("Sagittarius", 7, Date.new(BASIC_YEAR     ,11,23), Date.new(BASIC_YEAR    , 12,21))
  Capricorn   = Sign.new("Capricorn", 9,   Date.new(BASIC_YEAR     ,12,22), Date.new(BASIC_YEAR + 1, 1,19))
  Aquarius    = Sign.new("Aquarius", 10,   Date.new(BASIC_YEAR + 1 ,1,20),  Date.new(BASIC_YEAR + 1, 2,19))
  Pisces      = Sign.new("Pisces", 11,     Date.new(BASIC_YEAR + 1 ,2,20),  Date.new(BASIC_YEAR + 1, 3,20))

  private

  def self.date_before_mar_21?(date)
    (date.month < 3) || (date.month == 3 && date.day <= 20)
  end
end
