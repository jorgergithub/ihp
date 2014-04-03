class DailyFortune < ActiveRecord::Base
  validates :start_date, :end_date, :sunday, :monday, :tuesday, :wednesday,
            :thursday, :friday, :saturday, presence: true

  validate :start_and_end_dates_not_overlap_current_periods

  scope :active, -> {
    where { active.eq(true) }
  }

  scope :by_date, -> date {
    where { start_date.lteq(date) & end_date.gteq(date) }
  }

  def self.random
    daily_fortune = active.by_date(Date.current).first
    daily_fortune.send(week_day) if daily_fortune
  end

  private

  def self.week_day
    I18n.l(Date.current, format: "%A").downcase
  end

  def start_and_end_dates_not_overlap_current_periods
    daily_fortunes = DailyFortune.where { |klass|
      ((klass.start_date.lteq(start_date) & klass.end_date.gteq(start_date)) |
      (klass.start_date.lteq(end_date) & klass.end_date.gteq(end_date))) &
      (klass.id != id)
    }

    if daily_fortunes.any?
      errors.add(:base, "alreayd exists a period that contain the start date and/or end date")
    end
  end
end
