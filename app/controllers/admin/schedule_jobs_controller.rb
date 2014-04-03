class Admin::ScheduleJobsController < AuthorizedController
  before_filter :find_schedule_job

  def index
    @schedule_jobs = ScheduleJob.order("week_day, at").page(params[:page]).per(params[:per])
  end

  def edit
  end

  def update
    if @schedule_job.update_attributes(permitted_params)
      WheneverWorker.perform_async
      redirect_to admin_schedule_jobs_path, notice: "Schedule job was successfully updated."
    else
      render action: "edit"
    end
  end

  private

  def find_schedule_job
    @schedule_job = ScheduleJob.find(params[:id]) if params[:id]
  end

  def permitted_params
    params.require(:schedule_job).permit(:week_day, :at)
  end
end
