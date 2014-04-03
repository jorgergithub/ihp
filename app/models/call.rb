require "twilio"
require "call_duration_rounder"
require "random_utils"
require "phone_formatter"

class Call < ActiveRecord::Base
  belongs_to :client
  belongs_to :psychic
  belongs_to :invoice

  has_one :call_survey, dependent: :destroy
  has_one :survey, through: :call_survey

  has_many :credits, as: :target
  has_many :reviews

  delegate :alias_name, :full_name, to: :psychic, allow_nil: true, prefix: true

  before_save :calculate_duration

  scope :unprocessed, -> { where("processed IS NULL") }
  scope :processed, -> { where("processed IS NOT NULL") }
  scope :uninvoiced, -> { where("invoice_id IS NULL") }
  scope :period, -> (from, to) { where("started_at BETWEEN ? AND ?", from, to) }
  scope :completed, -> { where("status = ?", "completed") }

  def formatted_duration
    return "-" unless duration
    formatted = Time.at(duration*60).utc.strftime("%Hh %Mm")
    formatted.gsub!("00h ", "")
    formatted.gsub!("00m ", "")
    formatted
  end

  def formatted_number
    PhoneFormatter.format(from)
  end

  def parsed_start_time
    Time.parse(start_time).in_time_zone.strftime("%b %d, %Y %H:%M")
  end

  def parsed_start_time_only
    Time.parse(start_time).in_time_zone.strftime("%I:%M %p")
  end

  def parsed_start_date_only
    Time.parse(start_time).in_time_zone.strftime("%b %d, %Y")
  end

  def parsed_end_time
    Time.parse(end_time).in_time_zone
  end

  def twilio_account
    @twilio_account ||= TwilioHelper.client.account
  end

  def twilio_call
    @twilio_call ||= twilio_account.calls.get(sid)
  end

  def live_status
    twilio_call.status
  end

  def completed?
    live_status == "completed"
  end

  def process
    # Property          Description
    # sid               A 34 character string that uniquely identifies this resource.
    # parent_call_sid   A 34 character string that uniquely identifies the call that created this leg.
    # date_created      The date that this resource was created, given as GMT in RFC 2822 format.
    # date_updated      The date that this resource was last updated, given as GMT in RFC 2822 format.
    # account_sid       The unique id of the Account responsible for creating this call.
    # to                The phone number, SIP address or Client identifier that received this call. Phone numbers are in E.164 format (e.g. +16175551212). SIP addresses are formated as name@company.com. Client identifiers are formatted client:name.
    # from              The phone number, SIP address or Client identifier that made this call. Phone numbers are in E.164 format (e.g. +16175551212). SIP addresses are formated as name@company.com. Client identifiers are formatted client:name.
    # phone_number_sid  If the call was inbound, this is the Sid of the IncomingPhoneNumber that received the call. If the call was outbound, it is the Sid of the OutgoingCallerId from which the call was placed.
    # status            A string representing the status of the call. May be queued, ringing, in-progress, canceled, completed, failed, busy or no-answer. See 'Call Status Values' below for more information.
    # start_time        The start time of the call, given as GMT in RFC 2822 format. Empty if the call has not yet been dialed.
    # end_time          The end time of the call, given as GMT in RFC 2822 format. Empty if the call did not complete successfully.
    # duration          The length of the call in seconds. This value is empty for busy, failed, unanswered or ongoing calls.
    # price             The charge for this call, in the currency associated with the account. Populated after the call is completed. May not be immediately available.
    # price_unit        The currency in which Price is measured, in ISO 4127 format (e.g. usd, eur, jpy).
    # direction         A string describing the direction of the call. inbound for inbound calls, outbound-api for calls initiated via the REST API or outbound-dial for calls initiated by a <Dial> verb.
    # answered_by       If this call was initiated with answering machine detection, either human or machine. Empty otherwise.
    # forwarded_from    If this call was an incoming call forwarded from another number, the forwarding phone number (depends on carrier supporting forwarding). Empty otherwise.
    # caller_name       If this call was an incoming call to a phone number with Caller ID Lookup enabled, the caller's name. Empty otherwise.
    # uri               The URI for this resource, relative to https://api.twilio.com

    attributes = %w(parent_call_sid date_created date_updated account_sid
                    to from phone_number_sid status start_time end_time
                    price price_unit direction answered_by caller_name uri)

    attributes.each { |a| self.send("#{a}=", self.twilio_call.send(a)) }

    transaction do
      Rails.logger.info "[Call.process] #{self.twilio_call.inspect}"
      self.started_at = self.start_time
      self.ended_at = self.end_time

      self.duration = CallDurationRounder.new(twilio_call.duration).round
      self.calculate_cost_per_minute
      self.cost = self.duration * self.cost_per_minute
      self.rate = self.psychic.price
      self.client.discount_credits(self)

      self.original_duration = twilio_call.duration
      self.processed = true
      self.save
      self.send_statistics
    end

    psychic.finish_call!(self)
  end

  def calculate_cost_per_minute
    self.cost_per_minute = self.psychic.price_for(client)
  end

  def send_statistics
    ClientCallMailer.delay.client_call_statistics(self)
  end

  def self.process_calls
    unprocessed.each do |call|
      call.process
    end
  end

  def duration_str
    "#{duration == 0 ? "no" : duration} #{duration == 1 ? "minute" : "minutes"}"
  end

  def date
    created_at.strftime("%B %e, %Y")
  end

  def time
    created_at.strftime("%I:%M %p")
  end

  def survey_completed?
    call_survey.present?
  end

  def bonus?
    started_at.hour >= 0 && started_at.hour <= 8
  end

  def invoiced?
    invoice.present?
  end

  def refunded?
    status == "refunded"
  end

  def price_f
    self.price.to_f
  end

  def profit
    self.cost - self.price_f
  end

  private

  def calculate_duration
    self.duration = CallDurationRounder.new(self.original_duration).round
  end
end
