class Calls::ClientCallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    render text: ClientCallback.process(self)
  end
end
