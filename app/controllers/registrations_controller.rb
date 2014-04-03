class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :js

  def new
    build_resource({})
    self.resource.build_client
    self.resource.client.phones.build

    respond_with self.resource
  end

  def create
    @user = User.new
    @user.localized.update_attributes(user_params.merge({ role: "client" }))

    respond_to do |format|
      if @user.save
        format.html { redirect_to new_user_session_path, :notice => "Please confirm your account by clicking the email we just sent you" }
        format.js
      else
        format.html { render action: "new" }
        format.js { render :new }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:uid, :provider, :first_name, :last_name, :username, :email, :time_zone, :password, :password_confirmation,
      client_attributes: [:id, :birthday, :pin, phones_attributes: [:id, :desc, :number]])
  end
end
