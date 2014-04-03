class TrainingItemsController < AuthorizedController
  layout "main"

  def index
    @training_items = TrainingItem.all
    @psychic = current_psychic
  end

  def show
    @training_item = TrainingItem.find(params[:id])
    @psychic = current_psychic

    if @training_item.file
      @psychic.review_training!(@training_item)
      redirect_to @training_item.file
    end
  end
end
