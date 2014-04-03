class UnsubscribeController < ApplicationController
  layout "login"

  def unsubscribe
    if @client = Client.where(unsubscribe_key: params[:id]).first
      @client.unsubscribe_from_newsletters
    end
  end
end
