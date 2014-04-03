class CallbacksController < AuthorizedController
  def new
    @psychic = Psychic.find(params[:psychic_id])
    @callback = current_client.callbacks.new(psychic: @psychic)
  end

  def create
    params = callback_params.dup

    if params[:hours]
      @wait_for = (params.delete(:hours) || 0).to_i * 60 + (params.delete(:minutes) || 0).to_i
      params[:wait_for] = @wait_for
    end

    @callback = current_client.callbacks.new(params)
    respond_to do |format|
      if @callback.save
        format.html { redirect_to root_url, notice: "Your callback has been scheduled" }
        format.js
      else
        format.html { render action: "edit" }
        format.js
      end
    end
  end

  private

  def callback_params
    params.require(:callback).permit(:psychic_id, :wait_for, :hours, :minutes)
  end
end
