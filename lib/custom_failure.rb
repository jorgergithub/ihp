class CustomFailure < Devise::FailureApp
  def redirect_url
    if warden_options[:attempted_path] =~ /\/surveys\/[0-9]+/
      root_path
    else
      super
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
