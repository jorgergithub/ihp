class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :store_location

  before_action :find_page_seo
  before_action :find_horoscope
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :find_current_user
  around_action :user_time_zone, if: :current_user

  layout :layout_by_resource

  def page_seo
    @page_seo
  end

  def admin?
    request.subdomain == "admin"
  end
  helper_method :admin?

  def staff?
    request.subdomain == "staff"
  end
  helper_method :staff?

  def consumer?
    !staff? and !admin?
  end
  helper_method :consumer?

  def current_client
    return unless current_user and current_user.client?
    current_user.client
  end
  helper_method :current_client

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/" &&
        request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/sign_out" &&
        request.fullpath != "/users/password" &&
        request.fullpath !~ /^\/users\/confirmation/ &&
        request.fullpath !~ /^\/psychic\/search/ &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def redirect_to_user_dashboard(user)
    case user.role
    when "client"
      client_path
    when "psychic"
      psychic_path
    else
      root_path
    end
  end

  def after_sign_in_path_for(resource)
    if session[:previous_url].present? and session[:previous_url] != "/"
      session[:previous_url]
    else
      redirect_to_user_dashboard(resource)
    end
  end

  protected

  def find_horoscope
    @horoscope = Horoscope.last_by_date
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:login, :email, :username, :password, :first_name, :last_name, :create_as)
    end
  end

  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end

  def unauthorized
    if request.xhr?
      render :nothing => true, :status => :unauthorized
    else
      render :file => 'public/401', :layout => nil, :status => 401
    end
  end

  def find_page_seo
    @page_seo = PageSeo.for(request.path)
  end

  def find_current_user
    @client = current_client unless @client
  end

  def build_new_user
    @new_user = User.new
    @new_user.build_client
    @new_user.client.phones.build
    @new_user
  end
end
