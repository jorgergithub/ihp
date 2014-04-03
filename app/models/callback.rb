class Callback < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include TwilioIntegration

  belongs_to :psychic
  belongs_to :client

  delegate :alias_name, :full_name, to: :psychic, allow_nil: true, prefix: true

  scope :active, -> { where("status = ?", "active") }
  scope :current, -> { active.where("expires_at > ?", Time.now).order("expires_at") }
  scope :next, -> { active.where("expires_at > ?", Time.now).order("created_at") }

  def expired?
    return false unless expires_at
    !expires_at.future?
  end

  def wait_for=(v)
    if v.nil?
      self.expires_at = nil
      return
    end

    self.expires_at = Time.now + v.to_i.minutes
  end

  def wait_for
    return nil if self.expires_at.nil?
    seconds = (self.expires_at - Time.now)
    seconds.to_i / 60
  end

  def cancel_by_psychic
    update_status "cancelled_by_psychic"
  end

  def cancel_by_client
    update_status "cancelled_by_client"
  end

  def update_status(new_status)
    if new_status == "cancelled_by_psychic"
      handle_psychic_cancellation
    elsif new_status == "cancelled_by_client"
      handle_client_cancellation
    end

    update_attributes status: new_status
  end

  def handle_psychic_cancellation
    script = CallScript.for(client_call_sid)
    script.advance_to("psychic_cancelled")
    modify_call(client_call_sid, client_call_url)
  end

  def handle_client_cancellation
    script = CallScript.for(psychic_call_sid)
    script.advance_to("client_cancelled")
    modify_call(psychic_call_sid, psychic_call_url)
  end

  def psychic_call_url
    "#{ENV['BASE_URL']}/#{calls_psychic_callbacks_path}?callback_id=#{self.id}"
  end

  def client_call_url
    "#{ENV['BASE_URL']}/#{calls_client_callbacks_path}?callback_id=#{self.id}"
  end

  def execute
    client_call_response = psychic.call(psychic_call_url)
    psychic_call_response = client.call(client_call_url)

    self.psychic_call_sid = client_call_response.sid
    self.client_call_sid = psychic_call_response.sid
    self.save
  end

  def finish(call_sid)
    call = Call.new(sid: call_sid, psychic: self.psychic, client: self.client)
    if call.completed?
      call.process
      update_status "completed"
    else
      CallbackProcessorWorker.perform_async(self.id, call_sid)
    end
  end
end
