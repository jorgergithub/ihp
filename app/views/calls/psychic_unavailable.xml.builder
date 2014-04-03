xml.instruct!
xml.Response do
  xml.Gather(timeout: 15) do
    xml.Play "/prompts/psychic-unavailable-sorry.mp3"
  end
end
