xml.instruct!
xml.Response do
  xml.Gather(action: calls_url_for("pin", @phone_number), timeout: 15) do
    xml.Play "/prompts/001-index-welcome-back.mp3"
    xml.Say @client.first_name, voice: "woman"
    xml.Play "/prompts/001-index-enter-pin.mp3"
  end
end
