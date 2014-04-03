class Admin::PsychicsController < AuthorizedController
  before_filter :find_psychic

  def index
    respond_to do |format|
      format.html {
        @psychics = Psychic.includes(:user)

        if query = params[:q]
          @psychics = @psychics.where(<<-EOQ, query: "%#{query}%")
            CONCAT(psychics.pseudonym, ' ', users.last_name) LIKE :query OR
            CONCAT(users.first_name, ' ', users.last_name) LIKE :query OR
            users.username LIKE :query
          EOQ
        end

        @psychics = @psychics.order("users.first_name, users.last_name")
          .page(params[:page]).per(params[:per])
      }
      format.csv { send_data Psychic.to_csv }
    end
  end

  def new
    @user = User.new(create_as: "Psychic")
    @psychic = Psychic.new(user: @user)
    @user.psychic = @psychic
  end

  def edit
  end

  def disable
    @psychic.toggle_disabled!
    message = @psychic.disabled? ? "disabled" : "enabled"
    redirect_to admin_psychics_path, notice: "Psychic was successfully #{message}."
  end

  def available
    @psychic.available!
    redirect_to admin_psychics_path, notice: "Psychic was now available"
  end

  def unavailable
    @psychic.unavailable!
    redirect_to admin_psychics_path, notice: "Psychic was now unavailable"
  end

  def create
    @user = User.new(user_params).tap do |object|
      object.localized.assign_attributes(user_params)
    end

    if @user.save
      redirect_to admin_psychics_path, notice: "Psychic was successfully created"
    else
      @psychic = @user.psychic
      @psychic.user = @user
      render action: "edit"
    end
  end

  def update
    @user.skip_reconfirmation!
    if @user.localized.update_attributes(user_params)
      redirect_to edit_admin_psychic_path(@user.psychic.localized), notice: "Psychic was successfully updated."
    else
      render action: "edit"
    end
  end

  protected

  def find_psychic
    return unless params[:id]

    @psychic = Psychic.find(params[:id])
    @user = @psychic.user
  end

  def user_params
    ret = params.require(:user).permit(:id,
      :first_name, :last_name, :username, :email, :password, :password_confirmation,
      psychic_attributes: [ :id, :pseudonym, :ability_clairvoyance, :ability_clairaudient,
      :ability_clairsentient, :ability_empathy, :ability_medium,
      :ability_channeler, :ability_dream_analysis, :tools_tarot,
      :tools_oracle_cards, :tools_runes, :tools_crystals, :tools_pendulum,
      :tools_numerology, :tools_astrology, :specialties_love_and_relationships,
      :specialties_career_and_work, :specialties_money_and_finance,
      :specialties_lost_objects, :specialties_dream_interpretation,
      :specialties_pet_and_animals, :specialties_past_lives,
      :specialties_deceased, :style_compassionate, :style_inspirational,
      :style_straightforward, :about, :price,
      :extension, :address, :city, :country, :state, :featured,
      :postal_code, :phone, :cellular_number, :ssn, :date_of_birth,
      :emergency_contact, :emergency_contact_number, :us_citizen, :resume,
      :has_experience, :experience, :gift, :explain_gift, :age_discovered,
      :reading_style, :why_work, :friends_describe,
      :strongest_weakest_attributes, :how_to_deal_challenging_client,
      :specialties, :tools, :professional_goals, :how_did_you_hear, :other])
    ret.merge(role: "psychic")
  end
end
