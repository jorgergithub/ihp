class PsychicApplicationsController < ApplicationController
  layout :resolve_layout

  def new
    @psychic_application = PsychicApplication.new
  end

  def create
    @psychic_application = PsychicApplication.new.tap do |object|
      object.localized.assign_attributes(application_params)
    end

    if @psychic_application.save
      redirect_to confirmation_psychic_applications_path,
        notice: "Your application has been submitted."
    else
      render action: "new"
    end
  end

  def confirmation
    redirect_to email_confirmation_url
  end

  protected

  def application_params
    params.require(:psychic_application).permit(:first_name, :last_name,
      :email, :pseudonym, :username, :password, :time_zone, :address, :city, :country,
      :state, :postal_code, :phone, :cellular_number, :date_of_birth,
      :emergency_contact, :emergency_contact_number, :us_citizen, :resume,
      :has_experience, :experience, :gift, :explain_gift, :age_discovered,
      :reading_style, :why_work, :friends_describe,
      :strongest_weakest_attributes, :how_to_deal_challenging_client,
      :specialties, :tools, :professional_goals, :how_did_you_hear, :other,
      :terms)
  end

  def resolve_layout
    params[:layout] || "splash"
  end
end
