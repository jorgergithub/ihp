class PsychicsController < AuthorizedController
  skip_before_filter :authenticate_user!, only: [:new, :search, :about]
  before_filter :find_psychic, except: [:new, :search, :about]
  layout :resolve_layout

  before_action :build_new_user

  attr_accessor :resource, :resource_name
  helper_method :resource, :resource_name

  def new
    @resource = User.new
    @resource_name = "user"
  end

  def edit
  end

  def show
    @table = ScheduleTable.new(@psychic.weekly_schedule)
    @schedules = @psychic.next_week_schedules_by_date
    @new_schedule = @psychic.schedules.new
    @calls = @psychic.calls
  end

  def update
    respond_to do |format|
      if @psychic.localized.update_attributes(psychic_params)
        path = params[:redirect_to] || dashboard_path
        message = params[:redirect_message] || "Psychic was successfully updated."

        format.html { redirect_to path, notice: message }
        format.js
      else
        format.html { render action: "show" }
        format.js { render :update }
      end
    end
  end

  def search
    @client = current_client
    @psychics = Psychic.enabled.includes(:user).order("status")

    if params[:speciality]
      @psychics = @psychics.add_specialty_filter(params[:speciality])
    end

    if params[:tool]
      @psychics = @psychics.add_tool_filter(params[:tool])
    end

    if params[:status] == "available"
      @psychics = @psychics.available
    end

    if params[:price_min]
      @psychics = @psychics.where("price >= ?", params[:price_min])
    end

    if params[:price_max]
      @psychics = @psychics.where("price <= ?", params[:price_max])
    end

    if params[:featured]
      @psychics = @psychics.featured
    end

    if params[:text]
      @psychics = @psychics.by_alias_name(params[:text])
    end

    @psychics = @psychics.page(params[:page]).per(9)

    render :search, layout: false
  end

  def about
    @psychic = Psychic.find(params[:id])
    @table = ScheduleTable.new(@psychic.weekly_schedule)
  end

  def available
    @psychic.available!
    redirect_to dashboard_path, notice: "You're now available"
  end

  def unavailable
    @psychic.unavailable!
    redirect_to dashboard_path, notice: "You're now unavailable"
  end

  def avatar
    if params[:psychic][:avatar_id].present?
      preloaded = Cloudinary::PreloadedFile.new(params[:psychic][:avatar_id])

      respond_to do |format|
        if preloaded.valid? && @psychic.update_attribute(:avatar_id, preloaded.identifier)
          format.json { head :no_content }
        else
          format.json { render json: "Invalid upload signature", status: :unprocessable_entity }
        end
      end
    end
  end

  protected

  def find_psychic
    @psychic = current_psychic.localized
  end

  def psychic_params
    params.require(:psychic).permit(:phone, :ability_clairvoyance, :ability_clairaudient,
      :ability_clairsentient, :ability_empathy, :ability_medium, :ability_channeler,
      :ability_dream_analysis, :tools_tarot, :tools_oracle_cards, :tools_runes,
      :tools_crystals, :tools_pendulum, :tools_numerology, :tools_astrology,
      :specialties_love_and_relationships, :specialties_career_and_work,
      :specialties_money_and_finance, :specialties_lost_objects,
      :specialties_dream_interpretation, :specialties_pet_and_animals,
      :specialties_past_lives, :specialties_deceased, :style_compassionate,
      :style_inspirational, :style_straightforward, :about, :price, :top_speciality,
      schedules_attributes: [:id, :date, :start_time_string, :end_time_string, :_destroy])
  end

  def resolve_layout
    return "main" if %w[about show].include?(action_name)
  end
end
