class Admin::SubscribersController < AuthorizedController
  def index
    @subscribers = Subscriber.all

    respond_to do |format|
      format.html { @subscribers = @subscribers.order(:id).page(params[:page]).per(params[:per]) }
      format.csv  { send_data @subscribers.to_csv }
    end
  end

  def destroy
    @subscriber = Subscriber.find(params[:id])
    @subscriber.destroy

    redirect_to admin_subscribers_path, notice: 'Subscriber was successfully deleted.'
  end
end
