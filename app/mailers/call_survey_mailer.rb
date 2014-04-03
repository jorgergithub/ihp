class CallSurveyMailer < ActionMailer::Base
  default from: "noreply@iheartpsychics.com"

  def notify(user, call_survey, review)
    @user = user
    @call_survey = call_survey
    @review = review
    @call = @call_survey.call
    @client = @call.client
    @psychic = @call.psychic
    mail(to: "contact@iheartpsychics.com", subject: "I Heart Psychics - New Customer Survey Response")
  end
end
