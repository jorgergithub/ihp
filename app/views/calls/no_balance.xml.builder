xml.instruct!
xml.Response do
  xml.Gather(action: calls_url_for("topup", phone_number), numDigits: 1, timeout: 15) do
    xml.Play "/prompts/no-balance-1-thank-you.mp3"
    xml.Say @client.first_name, voice: "woman"
    xml.Play "/prompts/no-balance-2-out-of-credits.mp3"
    xml.Say "1", voice: "woman"
    xml.Play "/prompts/no-balance-3-other-options.mp3"
  end
end
