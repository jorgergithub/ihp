xml.instruct!
xml.Response do
  xml.Play "/prompts/do-transfer-1-thank-you.mp3"
  xml.Say @client.first_name
  xml.Play "/prompts/do-transfer-2-please-enjoy.mp3"
  xml.Dial(@psychic.phone,
    callerId: @caller_id, timeLimit: @client.seconds(@psychic),
    action: calls_url_for("call_finished", phone_number, @psychic))
end
