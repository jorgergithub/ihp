class ClientsController < AuthorizedController
  before_action :find_client

  layout :determine_layout

  def show
    # unless @client.balance?
    #   redirect_to :new_order
    #   return
    # end

    unless @client.pin?
      @pin = @client.set_random_pin
      ClientMailer.delay.pin_email(@client, @pin)
    end

    @transactions = @client.transactions.includes(:order).order('id desc').page(params[:page_credits]).per(params[:per])
    @phones = @client.phones.order(:id).page(params[:page_phones]).per(params[:per])
    @edit_phone = @client.phones.any? ? @client.phones.first : @client.phones.build
    @psychics = @client.psychics.order(:id).page(params[:page_psychics]).per(params[:per])
    @processed_calls = @client.calls.processed.includes(:psychic => :user).order(id: :desc).page(params[:page_processed_calls]).per(params[:per])
  end

  def edit
  end

  def update
    tmp_params = user_params

    if tmp_params[:password].try(:empty?)
      tmp_params.delete('password')
      tmp_params.delete('password_confirmation')
    end

    respond_to do |format|
      if @client.user.update_attributes(tmp_params) && @client.reload
        format.html { redirect_to edit_client_path, notice: "Client was successfully updated." }
        format.js
      else
        format.html { render action: "edit" }
        format.js
      end
    end
  end

  def add_credits
    if params[:client]
      if @client.add_credits(params[:client][:balance])
        redirect_to client_path, notice: "Credits added to your balance."
      else
        render action: "add_credits"
      end
    else
      @client.balance = nil
      @order = @client.orders.new
    end
  end

  def reset_pin
    if params[:client]
      pin = params.require(:client).permit(:pin)[:pin]
      respond_to do |format|
        if @client.reset_pin(pin)
          format.html { redirect_to client_path, notice: "Your PIN has been reset." }
          format.js
        else
          format.html { render action: "reset_pin" }
          format.js
        end
      end
    end
  end

  def make_favorite
    psychic = Psychic.find(params[:psychic_id])
    @client.favorite_psychics << psychic
    respond_to do |format|
      if @client.save
        format.html { redirect_to :back, notice: "#{psychic.alias_name} marked as favorite." }
        format.json { render json: @client, status: :created, location: @client }
        format.js { render text: "" }
      else
        format.html { redirect_to :back, error: "Could not mark as favorite." }
        format.json { render json: @subscriber.errors, status: :unprocessable_entity }
        format.js { render text: "" }
      end
    end
  end

  def remove_favorite
    psychic = Psychic.find(params[:psychic_id])
    @client.favorite_psychics.delete(psychic)
    respond_to do |format|
      if @client.save
        format.html { redirect_to :back, notice: "#{psychic.alias_name} removed from favorites." }
        format.json { render json: @client, status: :created, location: @client }
        format.js { render text: "" }
      else
        format.html { redirect_to :back, error: "Could not remove from favorites." }
        format.json { render json: @subscriber.errors, status: :unprocessable_entity }
        format.js { render text: "" }
      end
    end
  end

  def avatar
    if params[:client][:avatar_id].present?
      preloaded = Cloudinary::PreloadedFile.new(params[:client][:avatar_id])

      respond_to do |format|
        if preloaded.valid? && @client.update_attribute(:avatar_id, preloaded.identifier)
          format.json { head :no_content }
        else
          format.json { render json: "Invalid upload signature", status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy_card
    @client.cards.destroy_all

    respond_to do |format|
      format.js { render text: "" }
    end
  end

  protected

  def determine_layout
    "main"
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email,
      :password, :password_confirmation, :time_zone, client_attributes: [:id, :birthday, :receive_newsletters])
  end

  def find_client
    redirect_to :root unless current_user.client?
    @client = current_client
  end
end
