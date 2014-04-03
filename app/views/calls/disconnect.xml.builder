xml.instruct!
xml.Response do
  xml.Say <<-EOS.strip_heredoc, voice: "woman"
    Thank you for calling I Heart Psychics.
  EOS
  xml.Hangup
end
