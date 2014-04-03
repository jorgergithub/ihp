class Admin::SurveysController < AuthorizedController
  before_action :find_survey

  def index
    @surveys = Survey.order(:id).page(params[:page]).per(params[:per])
  end

  def new
    @survey = Survey.new
  end

  def edit
  end

  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      redirect_to edit_admin_survey_path(@survey), notice: "Survey was successfully created."
    else
      render action: "edit"
    end
  end

  def update
    if @survey.update_attributes(survey_params)
      # redirect_to admin_surveys_path, notice: "Survey was successfully updated."
      redirect_to edit_admin_survey_path(@survey), notice: "Survey was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    @survey.destroy

    redirect_to admin_surveys_path, notice: 'Survey was successfully deleted.'
  end

  protected

  def find_survey
    @survey = Survey.find(params[:id]) if params[:id]
  end

  def survey_params
    params.require(:survey).permit(:name, :active,
      questions_attributes: [:id, :type, :text, :_destroy,
        options_attributes: [:id, :text, :_destroy]])
  end
end
