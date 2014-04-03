class PsychicFaqsController < ApplicationController
  layout "main"

  def index
    @categories = PsychicFaqCategory.order(:name).all
  end
end
