require "twilio"

module TwilioIntegration
  def create_call(number, url)
    twilio_account.calls.create(from: "+17863295532", to: number, url: url)
  end

  def hangup_call(call_sid)
    twilio_account.calls.get(call_sid).hangup
  end

  def modify_call(call_sid, url)
    twilio_account.calls.get(call_sid).redirect_to(url)
  end

  def twilio_account
    @twilio_account ||= TwilioHelper.client.account
  end
end
