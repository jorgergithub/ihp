class Admin::DailyFortunesController < AuthorizedController
  before_filter :find_daily_fortune, except: [:index, :new]

  def index
    @daily_fortunes = DailyFortune.page(params[:page]).per(params[:per])
  end

  def new
    @daily_fortune = DailyFortune.new
  end

  def edit
  end

  def create
    @daily_fortune = DailyFortune.new(daily_fortune_params)
    if @daily_fortune.save
      redirect_to admin_daily_fortunes_path, notice: "Daily Fortune was successfully created."
    else
      render action: "edit"
    end
  end

  def update
    if @daily_fortune.update_attributes(daily_fortune_params)
      redirect_to admin_daily_fortunes_path, notice: "Daily Fortune was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    @daily_fortune.destroy
    redirect_to admin_daily_fortunes_path, notice: "Daily Fortune was successfully deleted."
  end

  protected

  def find_daily_fortune
    @daily_fortune = DailyFortune.find(params[:id]) if params[:id]
  end

  def daily_fortune_params
    params.require(:daily_fortune)
          .permit(:start_date, :end_date, :sunday, :monday, :tuesday,
                  :wednesday, :thursday, :friday, :saturday, :active)
  end
end
