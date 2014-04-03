class ClientWeeklyUsageReport
  def self.deliver
    start_date = 1.week.ago.in_time_zone.beginning_of_week(:sunday)
    end_date = 1.week.ago.in_time_zone.end_of_week(:saturday)

    Client.all.each do |client|
      self.deliver_for(client, start_date, end_date) if client.balance != nil &&
        client.balance > 0
    end
  end

  private

  def self.deliver_for(client, start_date, end_date)
    calls = client.calls.period(start_date, end_date)
    cost = total_cost(calls)
    duration = total_duration(calls)
    hearts = total_hearts(client.reviews)

    ClientWeeklyUsageMailer.delay.weekly_usage(start_date, client, calls, cost,
      duration, hearts)
  end

  def self.total_cost(calls)
    calls.map(&:cost).inject(0, :+)
  end

  def self.total_duration(calls)
    duration = calls.map(&:duration).inject(0, :+)

    formatted = Time.at(duration * 60).utc.strftime("%Hh %Mm")
    formatted.gsub!("00h ", "")
    formatted.gsub!("00m ", "")
    formatted
  end

  def self.total_hearts(reviews)
    reviews.map(&:rating).inject(0, :+)
  end
end
