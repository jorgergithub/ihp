class ClientCallback < CallScript
  def initial_state
    callback = ::Callback.find(self.context.params[:callback_id])
    send_menu <<-EOS, { "1" => :proceed, "2" => :cancel }
      Hello #{callback.client.first_name}, this is I Heart Psychics calling you for a callback with the psychic #{callback.psychic.alias_name}.

      If you are available and want to continue with the call, please press 1 now. Otherwise, press 2 and we'll cancel the callback.
    EOS
  end

  def proceed
    callback = ::Callback.find(self.context.params[:callback_id])
    send_to_conference "callback-#{callback.id}",
      message: "Please wait while we connect you with #{callback.psychic.alias_name}.",
      url: "/calls/client_callbacks?callback_id=#{callback.id}"
  end

  def conference_finished
    callback = ::Callback.find(self.context.params[:callback_id])
    callback.finish(self.call_sid)
  end

  def cancel
    callback = ::Callback.find(self.context.params[:callback_id])
    callback.cancel_by_client

    send_response <<-EOS
      Okay #{callback.client.first_name}, we are now cancelling your callback.
      Thank you.
    EOS
  end

  def psychic_cancelled
    callback = ::Callback.find(self.context.params[:callback_id])

    send_response <<-EOS
      We are sorry #{callback.client.first_name} but #{callback.psychic.alias_name}
      has become unavailable and will not be able to take your call at this moment.
    EOS
  end
end
