class TwilioHelper
  def self.client
    @client ||= begin
      account_sid = Rails.configuration.twilio[:account_sid]
      auth_token  = Rails.configuration.twilio[:auth_token]
      Twilio::REST::Client.new(account_sid, auth_token)
    end
  end
end
