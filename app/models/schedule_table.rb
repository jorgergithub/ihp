class ScheduleTable
  attr_reader :schedules

  HOURS = [ "12 AM", "01 AM", "02 AM", "03 AM", "04 AM", "05 AM", 
            "06 AM", "07 AM", "08 AM", "09 AM", "10 AM", "11 AM", 
            "12 PM", "01 PM", "02 PM", "03 PM", "04 PM", "05 PM", 
            "06 PM", "07 PM", "08 PM", "09 PM", "10 PM", "11 PM"]

  def initialize(schedules)
    @schedules = schedules.order("date ASC")
  end

  def row_by_hour(hour)
    first_date = schedules.first.date

    dates = []
    7.times do |index| 
      dates << first_date + index
    end

    dates.map do |date|
      schedules.where(date: date).select { |schedule| match_hour?(schedule, hour) }.first
    end
  end

  def match_hour?(schedule, hour)
    table_start_time    = Time.new(schedule.date.year, schedule.date.month, schedule.date.day, hour)
    table_end_time      = Time.new(schedule.date.year, schedule.date.month, schedule.date.day, hour)

    schedule_start_time = Time.new(schedule.date.year, schedule.date.month, schedule.date.day, schedule.start_time.hour, schedule.start_time.min)
    schedule_end_time   = Time.new(schedule.date.year, schedule.date.month, schedule.date.day, schedule.end_time.hour, schedule.end_time.min)
  
    schedule_start_time <= table_end_time && schedule_end_time >= table_start_time
  end
end