class ClientMailer < ActionMailer::Base
  default from: "noreply@iheartpsychics.com"

  def pin_email(client, pin)
    @client = client
    @pin = pin
    mail(to: client.email, subject: "I Heart Psychics - Your New Customer Account PIN")
  end

  def reset_pin_email(client)
    @client = client
    mail(to: client.email, subject: "I Heart Psychics - PIN Reset Confirmation")
  end
end
