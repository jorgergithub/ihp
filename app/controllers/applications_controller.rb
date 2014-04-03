class ApplicationsController < ApplicationController
  layout "main"

  def edit
  end

  def create
    @application = Application.new(application_params)
    if @application.valid?
      ApplicationMailer.new_application(@application).deliver
      redirect_to "#{careers_path}?select=resume", notice: "Your application has been sent."
    else
      render "home/careers", locals: {select: "resume"}
    end
  end

  private

  def application_params
    params.require(:application).permit(:first_name, :last_name, :email, :phone, :position, :attachment, :comments)
  end
end
