xml.instruct!
xml.Response do
  if @client
    xml.Gather(action: calls_url_for("pin", phone_number), timeout: 15) do
      xml.Play "/prompts/001-index-welcome-back.mp3"
      xml.Say @client.first_name, voice: "woman"
      xml.Play "/prompts/001-index-enter-pin.mp3"
    end
  else
    xml.Gather(action: calls_url_for("user", phone_number), timeout: 15) do
      xml.Play "/prompts/001-index-not-recognized.mp3"
    end
  end
end
