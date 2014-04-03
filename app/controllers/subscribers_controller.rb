class SubscribersController < ApplicationController
  def create
    @subscriber = Subscriber.new(subscriber_params)

    respond_to do |format|
      if @subscriber.save
        format.html { redirect_to @subscriber, notice: 'Subscriber was successfully created.' }
        format.json { render json: @subscriber, status: :created, location: @subscriber }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @subscriber.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  protected

  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end
