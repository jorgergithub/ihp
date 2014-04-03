class Admin::ReviewsController < AuthorizedController
  before_action :find_review

  def show
  end

  def mark_as_featured
    if @review.mark_as_featured!
      redirect_to edit_admin_psychic_path(@review.psychic), notice: "Review successfully marked as featured."
    else
      redirect_to :back, error: "Could not mark as featured."
    end
  end

  def unmark_as_featured
    if @review.unmark_as_featured!
      redirect_to edit_admin_psychic_path(@review.psychic), notice: "Review successfully unmarked as featured."
    else
      redirect_to :back, error: "Could not unmark as featured."
    end
  end

  protected

  def find_review
    @review = Review.find(params[:id]) if params[:id]
  end
end
