xml.instruct!
xml.Response do
  xml.Gather(action: calls_url_for("do_transfer", phone_number, @psychic), numDigits: 1, timeout: 15) do
    xml.Say <<-EOS.strip_heredoc, voice: "woman"
      We're sorry, you have entered an invalid option.
      You've requested to speak with #{@psychic.alias_name}.
      If this is correct, press one.
      If not, press two.
    EOS
  end
end
