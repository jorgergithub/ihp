class OrderMailer < ActionMailer::Base
  default from: "orders@iheartpsychics.com"

  def confirmation_email(order)
    @order = order
    @client = order.client
    mail(to: @client.email, subject: "I Heart Psychics - Dollars Purchase Notification")
  end
end
