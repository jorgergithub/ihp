class FaqsController < ApplicationController
  layout "main"

  before_action :build_new_user

  def index
    @categories = Category.all
  end
end
