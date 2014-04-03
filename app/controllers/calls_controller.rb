class CallsController < ApplicationController
  protect_from_forgery :except => :notify
  before_action :identify_client
  helper_method :phone_number

  def index
    logger.info "Index for: #{incoming_number}"
  end

  def user
    logger.info "Index for: #{incoming_number} -- #{params[:Digits]}"

    if params[:Digits] == "0"
      @csr = CustomerServiceRepresentative.next_available
      render :csr
      return
    end

    unless params[:Digits].present? and params[:Digits].length == 10
      render :user_error
      return
    end

    @phone_number = "+1#{params[:Digits]}"
    @client_phone = ClientPhone.where(number: @phone_number).take
    if @client_phone
      @client = @client_phone.client
      # record_call(params[:CallSid])
      logger.info "Got client: #{@client.inspect}"
    else
      logger.info "No client."
      render :user_error
    end
  end

  def pin
    logger.info "Received pin: [#{params[:Digits]}] [#{@client.try(:valid_pin?, params[:Digits])}] [#{params[:Digits].length == 4}]"

    unless params[:Digits].present? and params[:Digits].length == 4
      render :pin_error
      return
    end

    unless @client and @client.valid_pin?(params[:Digits])
      logger.info "Pin error - client: #{@client.inspect} pin: #{@client.try(:valid_pin?, params[:Digits])}"
      render :pin_error
      return
    end

    unless @client.balance and @client.balance >= 1
      render :no_balance
      return
    end

    logger.info "Pin valid - client: #{@client.inspect}"
  end

  def transfer
    unless params[:Digits].present? and params[:Digits].length == 4
      render :transfer_error
      return
    end

    unless @psychic = Psychic.where(extension: params[:Digits]).take
      render :transfer_error
      return
    end

    unless @psychic.available?
      render :psychic_unavailable
      return
    end

    @caller_id = ENV["CALLER_ID"] || "+1-855-550-8400"
  end

  def do_transfer
    unless params[:Digits].present?
      render :wrong_do_transfer_option
      return
    end

    if params[:Digits] == "2"
      render :pin
      return
    elsif params[:Digits] != "1"
      render :wrong_do_transfer_option
      return
    end

    @caller_id = ENV["CALLER_ID"] || "+1-855-550-8400"
    @psychic.on_a_call!
  end

  def topup
    if params[:Digits] == "1"
      @packages = Package.phone_offers
      render :credits
      return
    elsif params[:Digits] == "2"
      render :csr
      return
    elsif params[:Digits] == "3"
      render :disconnect
      return
    else
      render :bad_choice, locals: { redirect_to: "topup" }
      return
    end
  end

  def buy_credits
    choice = params[:Digits].to_i
    packages = Package.phone_offers
    csr_choice = packages.size + 1
    disconnect = csr_choice + 1

    if choice == csr_choice
      @csr = CustomerServiceRepresentative.next_available
      render :csr
      return
    end

    if choice == disconnect
      render :disconnect
      return
    end

    unless choice > 0 and choice <= packages.size
      render :bad_choice, locals: { redirect_to: "topup?Digits=1" }
      return
    end

    @package = packages[choice-1]
  end

  def confirm_credits
    card_id = @client.cards.first.try(:id)
    order = @client.orders.new(package_id: params[:package_id], card_id: card_id)
    if order.save
      order.pay
    else
      # todo
      raise "order didn't save"
    end

    @client.reload
    render :pin
  rescue Stripe::CardError
    logger.info "CardError: #{$!.message}"
    # todo
    raise $!
  end

  def call_finished
    sid        = params[:DialCallSid]
    status     = params[:DialCallStatus]
    duration   = params[:DialCallDuration]
    psychic_id = params[:psychic_id]

    case status
    when "completed"
      record_call(sid, psychic_id) # TODO make this an offline task
      check_credits

    when "busy", "no-answer", "failed", "canceled"
      @psychic.cancel_call!

      response = Twilio::TwiML::Response.new do |r|
        r.Play "/prompts/psychic-unavailable-sorry.mp3"
      end

      render text: response.text
    end
  end

  def notify
    logger.info "Params: #{params.inspect}"
    render nothing: true, status: :ok
  end

  def phone_number
    if @client_phone
      @client_phone.number
    elsif incoming_number
      incoming_number
    elsif digits = params[:Digits]
      digits = "+1#{digits}" unless digits =~ /^\+1/
      digits
    end
  end

  private

  def record_call(sid, psychic_id)
    return unless @client

    psychic = Psychic.find(psychic_id)
    psychic.available!

    call = @client.calls.create(sid: sid, psychic: psychic)
    call.process

    @client.reload
  end

  def check_credits
    return if @client.enough_balance_for(@psychic)

    render :no_balance_menu
  end

  def incoming_number
    number = params[:From] || params[:Caller]
    number = number.last(10)
    number = "+1#{number}" unless number =~ /^\+1/
    number
  end

  def identify_client
    logger.info "Trying to get client for: #{incoming_number}"
    @client_phone = ClientPhone.where(number: incoming_number).take
    logger.info "Client phone: #{@client_phone.inspect}"
    @client = @client_phone.client if @client_phone
    logger.info "Client: #{@client.inspect}"
    @csr = CustomerServiceRepresentative.next_available
    @psychic = Psychic.find(params[:psychic_id]) if params[:psychic_id]
  end
end
