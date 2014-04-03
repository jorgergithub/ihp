class AuthorizedController < ApplicationController
  before_filter :authenticate_user!

  enable_authorization

  rescue_from CanCan::Unauthorized, :with => :unauthorized

  def current_psychic
    return unless current_user and current_user.psychic?
    current_user.psychic
  end

  def current_csr
    return unless current_user and current_user.rep?
    current_user.rep
  end

  def current_admin
    return unless current_user and current_user.admin?
    current_user.admin
  end

  def disable_pagination?
    params[:page] == 'all'
  end
end
