class Admin::CallsController < ApplicationController
  include CallsHelper

  def index
    @client = Client.find(chosen_client) if chosen_client
    find_calls
  end

  def show
    find_client
    find_calls

    respond_to :js if request.xhr?
  end

  def refund
    @call = Call.find(params[:id]) if params[:id]

    if @call && CallRefund.new(@call).process!
      redirect_to admin_calls_path, :notice => "Call was successfully refunded."
    else
      flash[:error] = "Call was not refunded."
      redirect_to admin_calls_path
    end
  end

  def summary
    @calls = Call.all.page(params[:page]).per(params[:per])
    @start_date = params[:start_date]
    @end_date = params[:end_date]

    if @start_date.present? && @end_date.present?
      @calls = @calls.period(Date.strptime(params[:start_date], "%d-%m-%Y"),Date.strptime(params[:end_date], "%d-%m-%Y"))
    end

    @all_calls = Call.all

    @total_cost_of_calls = total_cost_of_calls(@all_calls)
    @total_price_of_calls = total_price_of_calls(@all_calls)
    @total_revenue_of_calls = total_revenue_of_calls(@all_calls)
  end

  private

  def find_client
    @client = Client.find(params[:id]) if params[:id]

    keep_chosen_client(params[:id]) if @client
  end

  def find_calls
    @calls = []

    return unless @client

    if @client.calls && @client.calls.processed
      @calls = @client.calls.processed.page(params[:page]).per(params[:per])
    end
  end

  def keep_chosen_client(client_id)
    session[:client_id] = client_id
  end

  def chosen_client
    session[:client_id]
  end
end
