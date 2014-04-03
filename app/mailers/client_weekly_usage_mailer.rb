class ClientWeeklyUsageMailer < ActionMailer::Base
  default from: "noreply@iheartpsychics.com"

  def weekly_usage(start_date, client, calls, cost, duration, hearts)
    @client = client
    @calls = calls
    @cost = cost
    @duration = duration
    @hearts = hearts
    @start_date = start_date

    title = "I Heart Psychics - Your Weekly Usage Report for the Week of #{@start_date}"
    mail(to: @client.email, subject: title)
  end
end
