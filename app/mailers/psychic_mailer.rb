class PsychicMailer < ActionMailer::Base
  default from: "noreply@iheartpsychics.com"

  def confirmation_email(psychic)
    @psychic = psychic
    mail(to: "recruiting@iheartpsychics.com",
         subject: "I Heart Psychics - New Psychic Application")
  end

  def approved_email(psychic, psychic_application)
    @psychic = psychic
    @psychic_application = psychic_application
    mail(to: psychic.email, subject: "I Heart Psychics – Your Psychic Application Has Been Approved")
  end

  def declined_email(psychic)
    @psychic = psychic
    mail(to: psychic.email, subject: "I Heart Psychic - Your Psychic Application Has Been Reviewed")
  end
end
