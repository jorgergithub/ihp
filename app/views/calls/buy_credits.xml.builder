xml.instruct!
xml.Response do
  xml.Gather(action: calls_url_for("confirm_credits?package_id=#{@package.id}", phone_number), numDigits: 1, timeout: 15) do
    xml.Play "/prompts/buy-credits-1-you-pressed.mp3"
    xml.Say params[:Digits], voice: "woman"
    xml.Play "/prompts/buy-credits-2-and-requested.mp3"
    xml.Say @package.credits.to_i, voice: "woman"
    xml.Play "/prompts/buy-credits-3-dollars-for.mp3"
    xml.Say price_to_phrase(@package.price), voice: "woman"
    xml.Play "/prompts/buy-credits-4-menu.mp3"
    # xml.Say <<-EOS.strip_heredoc, voice: "woman"
    #   You have chosen to add #{price_to_phrase @package.credits} to your account
    #   for #{price_to_phrase(@package.price)}.
    #   Press 1 to confirm or press 2 to return to the previous menu.
    # EOS
  end
end
