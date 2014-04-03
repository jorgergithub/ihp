class ClientCallMailer < ActionMailer::Base
  default from: "noreply@iheartpsychics.com"

  def client_call_statistics(call)
    @call = call
    @client = call.client
    @psychic = call.psychic

    title = "I Heart Psychics - Your Call Summary With #{@psychic.alias_name} on #{call.date}"
    mail(to: @client.email, subject: title)
  end
end
