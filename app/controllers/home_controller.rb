require 'time_ext'

class HomeController < AuthorizedController
  # before_filter :authenticate_user!, except: [:index, :apna, :confirmation]
  skip_filter :authenticate_user!
  layout :select_layout

  before_action :build_new_user

  def index
    return if go_home

    @psychics = Psychic.all
    @client = current_user.client if current_user
  end

  def staff
    go_home(true) if current_user
  end

  def apna
  end

  def ethics
  end

  def contact
    @message = Message.new
  end

  def careers
    @application = Application.new
  end

  def dictionary
  end

  def how_it_works
  end

  def privacy
  end

  def terms
  end

  def show
    go_home(true)
  end

  def confirmation
  end

  protected

  def go_home(dashboard=false)
    unless current_user
      redirect_to root_path if dashboard
      return false
    end

    if dashboard and current_user.client?
      redirect_to client_path
      return true
    elsif current_user.psychic?
      redirect_to psychic_path
      return true
    elsif current_user.rep?
      redirect_to customer_service_representative_path
      return true
    elsif current_user.admin?
      redirect_to admin_dashboard_path
      return true
    elsif current_user.manager_director?
      redirect_to admin_psychic_applications_path
      return true
    elsif current_user.website_admin?
      redirect_to admin_dashboard_path
      return true
    elsif current_user.accountant?
      redirect_to pending_admin_invoices_path
      return true
    end
  end

  def select_layout
    if action_name == "show"
      return "application"
    elsif action_name == "apna"
      return "splash-nologo"
    else
      return "main"
    end
  end
end
