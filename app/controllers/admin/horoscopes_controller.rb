class Admin::HoroscopesController < AuthorizedController
  before_action :find_horoscope

  def index
    redirect_to edit_admin_horoscope_path(Date.today)
  end

  def new
    @horoscope = Horoscope.new
  end

  def edit
  end

  def create
    @horoscope = Horoscope.new(horoscope_params)
    if @horoscope.save
      redirect_to edit_admin_horoscope_path(@horoscope.date), notice: "Horoscope was successfully created."
    else
      render action: "edit"
    end
  end

  def update
    if @horoscope.update_attributes(horoscope_params)
      redirect_to edit_admin_horoscope_path(@horoscope.date), notice: "Horoscope was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    @horoscope.destroy

    redirect_to admin_horoscopes_path, notice: 'Horoscope was successfully deleted.'
  end

  protected

  def horoscope_params
    params.require(:horoscope).permit(:date, :aries, :taurus, :gemini, :cancer,
      :leo, :virgo, :libra, :scorpio, :sagittarius, :capricorn, :aquarius,
      :pisces, :lovescope, :friendship_compatibility_to, :friendship_compatibility_from, 
      :love_compatibility_to, :love_compatibility_from)
  end

  def find_horoscope
    if params[:id]
      begin
        @today = Date.parse(params[:id])
        @horoscope = Horoscope.where(date: params[:id]).take
        @horoscope = Horoscope.new(date: params[:id]) unless @horoscope
      rescue ArgumentError
        @horoscope = Horoscope.find(params[:id])
      end
    end
  end
end
