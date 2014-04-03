class SessionsController < Devise::SessionsController
  respond_to :js

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    @path = after_sign_in_path_for(resource)
    respond_with resource, :location => @path
  end
end
