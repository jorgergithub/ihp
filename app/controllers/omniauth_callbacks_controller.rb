class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env["omniauth.auth"]
    user = User.from_omniauth(self.send("#{auth.provider}_params", auth))

    if user.persisted?
      flash[:notice] = "Signed in!"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  alias_method :twitter, :all
  alias_method :facebook, :all
  alias_method :google_oauth2, :all

  private

  def facebook_params(auth)
    {
      create_as: 'client',
      email: auth.info.email,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      provider: auth.provider,
      uid: auth.uid,
      username: auth.info.nickname
    }
  end

  def twitter_params(auth)
    {
      create_as: 'client',
      first_name: auth.info.name.split.first,
      last_name: auth.info.name.split.last,
      provider: auth.provider,
      uid: auth.uid,
      username: auth.info.nickname
    }
  end

  def google_oauth2_params(auth)
    {
      create_as: 'client',
      email: auth.info.email,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      provider: auth.provider,
      uid: auth.uid,
      username: auth.info.email.split('@').first
    }
  end
end
