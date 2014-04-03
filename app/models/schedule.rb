class Schedule < ActiveRecord::Base
  include ActionView::Helpers::TranslationHelper
  include I18n::Alchemy

  belongs_to :psychic

  scope :weekly, -> { where("date BETWEEN ? and ?", Date.today, Date.today + 7.days) }

  attr_accessor :start_hour, :start_minute, :start_period
  attr_accessor :end_hour, :end_minute, :end_period

  def start_hour
    start_time_string[0..1]
  end

  def start_minute
    start_time_string[3..4]
  end

  def start_period
    start_time_string[6..7]
  end

  def end_hour
    end_time_string[0..1]
  end

  def end_minute
    end_time_string[3..4]
  end

  def end_period
    end_time_string[6..7]
  end

  def start_time_string
    return "" unless start_time
    l(start_time.in_time_zone, format: :schedule)
  end

  def start_time_string=(start_time_string)
    self.start_time = Time.zone.parse(start_time_string)
  rescue ArgumentError
    @start_time_invalid = true
  end

  def end_time_string
    return "" unless end_time
    l(end_time.in_time_zone, format: :schedule)
  end

  def end_time_string=(end_time_string)
    self.end_time = Time.zone.parse(end_time_string)
  rescue ArgumentError
    @end_time_invalid = true
  end

  def validate
    errors.add(:start_time, "is invalid") if @start_time_invalid
    errors.add(:end_time, "is invalid") if @end_time_invalid
  end
end
