class PsychicApplication < ActiveRecord::Base
  include I18n::Alchemy

  validates :first_name, :last_name, :pseudonym, :username, :password, :email, :time_zone,
            :address, :city, :country, :state, :postal_code, :date_of_birth,
            :experience, :gift, :explain_gift, :age_discovered, :reading_style,
            :why_work, :friends_describe, :strongest_weakest_attributes,
            :how_to_deal_challenging_client, :tools, :specialties, :professional_goals,
            :how_did_you_hear, presence: true
  validates :price, presence: true, if: :persisted?
  validates :us_citizen, inclusion: { in: [true, false], message: "can't be blank" }
  validates :has_experience, inclusion: { in: [true, false], message: "can't be blank" }
  validates :phone, as_phone_number: true, if: ->(pa) { pa.phone.present? }
  validates :cellular_number, as_phone_number: true, if: ->(pa) { pa.cellular_number.present? }
  validates :emergency_contact_number, as_phone_number: true, if: ->(pa) { pa.emergency_contact_number.present? }
  validates :terms, acceptance: { accept: true }

  localize :phone, :cellular_number, :emergency_contact_number, :using => PhoneParser
  localize :date_of_birth, :using => KeepDateParser

  mount_uploader :resume, ResumeUploader

  after_create :send_confirmation_email

  scope :pending, -> { where("approved_at IS NULL AND declined_at IS NULL") }

  def to_s
    full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def decline!
    ActiveRecord::Base.transaction do
      self.declined_at = Time.now
      self.save!

      PsychicMailer.delay.declined_email(self)
    end
  end

  # FIXME Specialties copy is broken
  def approve!
    ActiveRecord::Base.transaction do
      user = create_user_as_psychic!

      self.approved_at = Time.now
      self.save!

      PsychicMailer.delay.approved_email(user.psychic, self)
    end
  end

  def alias_name
    "#{pseudonym} #{last_name.first}"
  end

  protected

  def send_confirmation_email
    PsychicMailer.delay.confirmation_email(self)
  end

  private

  def create_user_as_psychic!
    user = User.new(create_as: "psychic")

    %w[first_name last_name username password email time_zone].each do |f|
      user.send("#{f}=", send(f))
    end

    user.skip_confirmation!
    user.save!

    update_psychic_attributes!(user.psychic)

    user
  end

  def update_psychic_attributes!(psychic)
    fields = %w[pseudonym price address city country state postal_code phone
                cellular_number date_of_birth emergency_contact
                emergency_contact_number us_citizen resume has_experience
                experience gift explain_gift age_discovered
                reading_style why_work friends_describe
                strongest_weakest_attributes how_to_deal_challenging_client
                specialties professional_goals how_did_you_hear other]

    fields.each do |f|
      psychic.send("#{f}=", send(f))
    end

    psychic.save!
  end
end
