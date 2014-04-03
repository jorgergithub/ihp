class Admin::CallSurveysController < AuthorizedController
  before_action :find_call_survey

  def show
  end

  protected

  def find_call_survey
    @call_survey = CallSurvey.find(params[:id]) if params[:id]
  end
end
