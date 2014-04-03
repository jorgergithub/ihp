class ContactMailer < ActionMailer::Base
  default from: "noreply@iheartpsychics.com"

  def new_message(message)
    @message = message
    mail(to: "info@iheartpsychics.com", subject: "I Heart Psychics - New Contact Us message")
  end
end
