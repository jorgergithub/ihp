class MessagesController < ApplicationController
  layout "main"

  def edit
  end

  def create
    @message = Message.new(message_params)
    if @message.valid?
      ContactMailer.new_message(@message).deliver
      redirect_to contact_path, notice: "Your message was sent."
    else
      render "home/contact"
    end
  end

  private

  def message_params
    params.require(:message).permit(:name, :email, :phone, :suggestions)
  end
end
