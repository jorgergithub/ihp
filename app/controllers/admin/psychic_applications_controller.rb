class Admin::PsychicApplicationsController < AuthorizedController
  before_filter :find_psychic_application

  def index
    @psychic_applications = PsychicApplication.pending
                                              .order("created_at")
                                              .page(params[:page])
                                              .per(params[:per])
  end

  def show
  end

  def update
    @psychic_application.localized.assign_attributes(psychic_application_params)

    if params[:commit] == "Approve"
      @psychic_application.approve!
      redirect_to admin_psychic_applications_path, notice: "Psychic approved successfully."
    elsif params[:commit] == "Decline"
      @psychic_application.decline!
      redirect_to admin_psychic_applications_path, notice: "Psychic declined successfully."
    end
  rescue ActiveRecord::RecordInvalid
    flash[:error] = format_record_invalid_message($!.message)
    render action: :show
  end

  protected

  def find_psychic_application
    @psychic_application = PsychicApplication.find(params[:id]).localized if params[:id]
  end

  private

  def psychic_application_params
    params.require(:psychic_application).permit(:phone, :price)
  end

  def format_record_invalid_message(message)
    message.gsub!("Phone", "Landline Number") if message =~ /Phone/
    message
  end
end
