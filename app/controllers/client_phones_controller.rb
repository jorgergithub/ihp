class ClientPhonesController < AuthorizedController
  before_filter :find_phone

  def new
    @phone = ClientPhone.new
  end

  def edit
  end

  def create
    @phone = current_client.phones.build.tap do |object|
      object.localized.assign_attributes(phone_params)
    end

    respond_to do |format|
      if @phone.save
        format.html { redirect_to client_path, notice: "New phone was successfully created." }
        format.js { render :update }
      else
        format.html { render action: "new" }
        format.js { render :update }
      end
    end
  end

  def update
    respond_to do |format|
      if @phone.localized.update_attributes(phone_params)
        format.html { redirect_to client_path, notice: "Phone was successfully updated." }
        format.js
      else
        format.html { render action: "edit" }
        format.js
      end
    end
  end

  def destroy
    @phone.destroy

    redirect_to client_path, notice: 'Phone was successfully deleted.'
  end

  protected

  def find_phone
    @client = current_client
    @phone = @client.phones.find(params[:id]).localized if params[:id]
  end

  def phone_params
    params.require(:client_phone).permit(:number, :desc)
  end
end