class CallScript < ActiveRecord::Base
  attr_accessor :context
  serialize :params

  def self.for(call_sid)
    self.where(call_sid: call_sid).first_or_initialize
  end

  def self.process(context)
    call_sid = context.params[:CallSid]
    self.for(call_sid).process(context)
  end

  def context=(c)
    @context = OpenStruct.new(
      digits: c.params[:Digits],
      params: c.params
    )
  end

  def process(context)
    self.context = context
    self.next_action ||= "initial_state"
    action = self.next_action
    response = send(self.next_action)
    save

    Rails.logger.info "Response for action [#{action}] - #{response}"

    return response
  end

  def advance_to(new_action)
    self.update_attributes next_action: new_action
  end

  def send_menu(greet, options)
    self.next_action = "process_menu_result"
    self.params = {menu_options: options}

    num_digits = options.keys.group_by(&:length).max.first
    gather_options = if num_digits > 1
      options = { finishOnKey: "#" }
    else
      options = { numDigits: num_digits }
    end
    options.merge!({ timeout: "15" })

    Twilio::TwiML::Response.new do |r|
      r.Gather(gather_options) { |g| g.Say greet }
    end.text
  end

  def process_menu_result
    action = self.params[:menu_options][context.digits.to_s]

    unless action
      response = Twilio::TwiML::Response.new do |r|
        options = self.params[:menu_options].keys
        r.Say <<-EOS
          The option you selected is invalid.
          Please enter #{options.to_sentence(two_words_connector: " or ", last_word_connector: " or ")}.
        EOS
      end
      return response.text
    end

    self.next_action = action
    self.process(self.context)
  end

  def send_to_conference(conference, options={})
    self.next_action = "conference_finished"

    message = options[:message]
    url = options[:url]
    dial_options = {endConferenceOnExit: true}
    dial_options[:action] = "#{ENV['BASE_URL']}#{url}" if url

    Twilio::TwiML::Response.new do |r|
      r.Say(message) if message
      r.Dial(dial_options) do |d|
        d.Conference(conference)
      end
    end.text
  end

  def send_response(message)
    Twilio::TwiML::Response.new do |r|
      r.Say(message)
    end.text
  end

  def conference_finished
    # does nothing by default
  end
end
