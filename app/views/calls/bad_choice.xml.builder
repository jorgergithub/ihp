xml.instruct!
xml.Response do
  xml.Say <<-EOS.strip_heredoc, voice: "woman"
    We're sorry. The option you selected is invalid.
  EOS
  xml.Redirect(calls_url_for(redirect_to, phone_number), method: "GET")
end
