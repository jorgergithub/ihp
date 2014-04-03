class PsychicCallback < CallScript
  def initial_state
    callback = ::Callback.find(self.context.params[:callback_id])
    send_menu <<-EOS, { "1" => :proceed, "2" => :cancel }
      Hello #{callback.psychic.first_name}, this is I Heart Psychics
      calling you for a callback with #{callback.client.first_name}.

      If you are available and want to continue with the call, please
      press 1 now. Otherwise, press 2 and we'll cancel the callback.
    EOS
  end

  def proceed
    callback = ::Callback.find(self.context.params[:callback_id])
    send_to_conference "callback-#{callback.id}",
      message: "Please wait while we connect #{callback.client.first_name}.",
      url: "/calls/psychic_callbacks?callback_id=#{callback.id}"
  end

  def cancel
    callback = ::Callback.find(self.context.params[:callback_id])
    callback.cancel_by_psychic

    send_response <<-EOS
      Okay #{callback.psychic.first_name}, we are now cancelling your callback.
      Thank you.
    EOS
  end

  def client_cancelled
    callback = ::Callback.find(self.context.params[:callback_id])

    send_response <<-EOS
      We are sorry #{callback.psychic.first_name} but #{callback.client.first_name}
      has cancelled this callback and will not be able to take your call at this moment.
    EOS
  end
end
