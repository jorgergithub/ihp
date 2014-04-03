xml.instruct!
xml.Response do
  xml.Gather(timeout: 15) do
    xml.Play "/prompts/pin-error-1-sorry.mp3"
    xml.Say @client.first_name, voice: "woman"
    xml.Play "/prompts/pin-error-2-incorrect.mp3"
  end
end
