class Calls::PsychicCallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    render text: PsychicCallback.process(self)
  end
end
