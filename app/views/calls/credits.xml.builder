xml.instruct!
xml.Response do
  xml.Gather(action: calls_url_for("buy_credits", phone_number), timeout: 15, numDigits: 1) do
    i = 1
    @packages.each do |pkg|
      xml.Play "/prompts/credits-#{i}-press-#{i}.mp3"
      xml.Say pkg.credits.to_i, voice: "woman"
      xml.Play "/prompts/credits-5-dollars-to-your-account.mp3"
      xml.Say price_to_phrase(pkg.price), voice: "woman"
      i += 1
    end
    xml.Play "/prompts/credits-4-press-4.mp3"
  end
end
