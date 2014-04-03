xml.instruct!
xml.Response do
  xml.Gather(action: calls_url_for("do_transfer", phone_number, @psychic), numDigits: 1) do
    xml.Play "/prompts/transfer-1-requested.mp3"
    xml.Say @psychic.alias_name, voice: "woman"
    xml.Play "/prompts/transfer-2-extension.mp3"
    xml.Say @psychic.extension, voice: "woman"
    xml.Play "/prompts/transfer-3-menu.mp3"

    # xml.Say <<-EOS.strip_heredoc, voice: "woman"
    #   You've requested to speak with #{@psychic.alias_name}
    #   at a rate of #{price_to_phrase @psychic.price_for(@client)} per minute.
    #   Based on your balance, you have #{@client.minutes_with(@psychic)} minutes
    #   available with this reader.
    #   If this is correct, press one.
    #   If not, press two.
    # EOS
  end
end
