xml.instruct!
xml.Response do
  xml.Gather(action: calls_url_for("transfer", phone_number), timeout: 15) do
    xml.Play "/prompts/pin-thank-you.mp3"
    xml.Say @client.first_name, voice: "woman"
    xml.Play "/prompts/pin-you-have.mp3"
    xml.Say @client.balance.to_i, voice: "woman"
    xml.Play "/prompts/pin-dollars-remaining.mp3"
  end
end
