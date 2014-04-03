require "random_utils"
require "date_time_mixin"
require "csv_exportable"
require "inherited_inspect"

class Psychic < ActiveRecord::Base
  include CsvExportable
  include I18n::Alchemy
  include InheritedInspect
  include TwilioIntegration

  STATES = %w[unavailable available on_a_call]

  SPECIALTIES = %w[specialties_love_and_relationships
                  specialties_career_and_work specialties_money_and_finance
                  specialties_lost_objects specialties_dream_interpretation
                  specialties_pet_and_animals specialties_past_lives
                  specialties_deceased]

  TOOLS = %w(tools_tarot tools_oracle_cards tools_runes tools_crystals
             tools_pendulum tools_numerology tools_astrology)

  has_enumeration_for :top_speciality, create_helpers: true

  belongs_to :user

  has_many :calls, -> { order("id DESC") }
  has_many :events, class_name: "PsychicEvent"
  has_many :hours
  has_many :invoices
  has_many :reviews
  has_many :schedules
  has_many :callbacks
  has_many :psychic_training_items
  has_many :training_items, through: :psychic_training_items

  has_and_belongs_to_many :favorited_by_clients, class_name: "Client"

  accepts_nested_attributes_for :schedules, allow_destroy: true,
    reject_if: proc { |attr|
      attr["start_time_string"].blank? || attr["end_time_string"].blank?
    }

  delegate :username, :first_name, :last_name, :full_name, :email,
           to: :user, allow_nil: true

  delegate :unavailable?, :available?, :on_a_call?, to: :current_state

  validates :extension, uniqueness: true
  validates :phone, :price, :pseudonym, presence: true
  validates :phone, as_phone_number: true, if: ->(p) { p.phone.present? }

  localize :phone, :cellular_number, :emergency_contact_number, using: PhoneParser

  mount_uploader :resume, ResumeUploader

  before_create :assign_extension

  scope :by_alias_name, ->(value) {
    joins(:user).
    where("CONCAT(psychics.pseudonym, ' ', SUBSTR(users.last_name, 1, 1)) LIKE ?", "%#{value}%").
    order("psychics.pseudonym, SUBSTR(users.last_name, 1, 1)")
  }
  scope :enabled,   -> { where("disabled IS NOT true")}
  scope :available, -> { enabled.where("status = ?", "available") }
  scope :featured,  -> { enabled.where("featured IS true") }

  def self.available_count
    available.size
  end

  def self.add_field_filter(field, value, prefix, collection)
    raise "invalid #{field} #{value}" unless collection.include?("#{prefix}#{value}")

    scope = self
    collection.each do |s|
      expected = s.gsub(/^#{prefix}/, "")
      if value == expected
        scope = scope.where("#{s} IS true")
      end
    end
    scope
  end

  def self.add_specialty_filter(specialty)
    self.add_field_filter("specialty", specialty, "specialties_", SPECIALTIES)
  end

  def self.add_tool_filter(tool)
    self.add_field_filter("tool", tool, "tools_", TOOLS)
  end

  def current_state
    (events.last.try(:state) || STATES.first).inquiry
  end

  def featured_reviews
    reviews.featured
  end

  def regular_reviews
    reviews.regular
  end

  def rating
    reviews.average(:rating)
  end

  def specialties
    %w(specialties_love_and_relationships specialties_career_and_work
       specialties_money_and_finance specialties_lost_objects
       specialties_dream_interpretation specialties_pet_and_animals
       specialties_past_lives specialties_deceased).inject([]) do |arr, sp|

      arr << sp.gsub("specialties_", "").gsub("_", " ") if send(sp)
      arr

    end.join(", ")
  end

  def alias_name
    "#{pseudonym} #{last_name.first}"
  end

  def weekly_schedule
    delta = 5 - Date.today.in_time_zone.to_date.wday
    delta += 7 if delta < 0

    first_date = Date.today.in_time_zone.to_date
    last_date = first_date + delta.days

    schedules.where('date >= ? AND date <= ?', first_date, last_date)
  end

  def next_week_schedules
    today = Date.today.in_time_zone.to_datetime.extend(DateTimeMixin)
    start_date = today.next_wday(6)
    end_date = start_date + 6.days

    schedules.where("date >= ? AND date <= ?", start_date.to_date, end_date.to_date)
  end

  def next_week_schedules_by_date
    today = Date.today.in_time_zone.to_datetime.extend(DateTimeMixin)
    start_date = today.next_wday(6)
    end_date = start_date + 6.days

    (start_date..end_date).inject({}) do |h, date|
      result = schedules.where(date: date.to_date)
      if result.count > 0
        h[date] = result.load.to_a
      else
        h[date] = [schedules.new(date: date)]
      end
      h
    end
  end

  def available!
    events.create! state: "available"
    hours.create! action: "start"
    update_attributes status: "available"
    CallbackWorker.perform_async(self.id)
  end

  def unavailable!
    events.create! state: "unavailable"
    hours.create! action: "finish"
    update_attributes status: "unavailable"
  end

  def on_a_call!
    events.create! state: "on_a_call"
    hours.create! action: "call_start"
    update_attributes status: "on_a_call"
  end

  def cancel_call!
    if on_a_call?
      events.create! state: "available"
      hours.last.destroy
    end
  end

  def finish_call!(call)
    if on_a_call?
      events.create! state: "available"
      hours.last.update_attribute :call_id, call.id
      hours.create! action: "call_finish", call: call
    end
  end

  def can_callback?(client)
    return false if available?
    client.balance >= price * 10
  end

  def call(call_url)
    create_call(self.phone, call_url)
  end

  def assign_extension
    return if self.extension
    existing_extensions = Psychic.pluck("extension")
    self.extension = RandomUtils.random_extension(existing_extensions)
  end

  def sign
    Sign.by_date(date_of_birth)
  end

  def total_calls_in_period
    calls.uninvoiced.count
  end

  def total_minutes_in_period
    calls.uninvoiced.sum(:duration)
  end

  def avg_minutes_in_period
    calls.uninvoiced.average(:duration).to_i
  end

  def current_tier
    Tier.for(total_minutes_in_period)
  end

  def current_tier_name
    current_tier.try(:name)
  end

  def payout_percentage_in_period
    current_tier.percent
  end

  def convert_to_enum(items, prefix)
    results = []
    items.each do |field|
      tool_name = field.gsub(/^#{prefix}/, "").humanize
      results << tool_name if send(field)
    end
    results
  end

  def tools_enum
    convert_to_enum(TOOLS, "tools_")
  end

  def specialties_enum
    convert_to_enum(SPECIALTIES, "specialties_")
  end

  def styles_enum
    items = %w(style_compassionate style_inspirational style_straightforward)
    convert_to_enum(items, "style_")
  end

  def abilities_enum
    items = %w(ability_clairvoyance ability_clairaudient ability_clairsentient
               ability_empathy ability_medium ability_channeler
               ability_dream_analysis)
    convert_to_enum(items, "ability_")
  end

  def pending_invoices
    invoices.pending
  end

  def paid_invoices
    invoices.paid
  end

  def callbacks?
    callbacks.current.any?
  end

  def no_callbacks?
    !callbacks?
  end

  def estimated_wait
    return 0 if available? and no_callbacks?

    wait_time = 0

    if on_a_call?
      if events.any?
        current_call_length = ((Time.zone.now - events.last.created_at) / 60).to_i
        fifteen_minutes_slots = (current_call_length / 15).to_i
        time_to_next_slot = current_call_length - (15 * (fifteen_minutes_slots))

        wait_time += (15 - time_to_next_slot)
      end
    end

    if callbacks?
      wait_time += callbacks.current.count * 15
    end

    return wait_time
  end

  def current_call_length
    return 0 unless on_a_call?
    ((Time.zone.now - events.last.created_at) / 60).to_i
  end

  def review_training!(training_item)
    training_items << training_item
    save
  end

  def training_reviewed?(training_item)
    psychic_training_items.where(training_item: training_item).any?
  end

  def training_complete?
    TrainingItem.where(
      "id not in (" +
      "select training_item_id from psychic_training_items " +
      "where psychic_id=?)", id).count == 0
  end

  def toggle_disabled!
    update_attributes disabled: !self.disabled
  end

  def special_price?(client)
    return false if client && !client.new_client?
    return false if self.price > 4
    true
  end

  def price_for(client)
    return 1 if special_price?(client)
    self.price
  end

  def self.additional_csv_columns
    ['email']
  end
end
