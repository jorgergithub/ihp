xml.instruct!
xml.Response do
  xml.Gather(timeout: 15) do
    xml.Play "/prompts/transfer-error-sorry.mp3"
    xml.Play "/prompts/transfer-error-invalid-extension.mp3"
  end
end
