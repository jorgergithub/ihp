class ReviewsController < AuthorizedController
  before_filter :find_review

  def mark_as_featured
    respond_to do |format|
      if @review.mark_as_featured!
        format.html { redirect_to edit_psychic_path, notice: "Review successfully marked as featured." }
        format.js
      else
        format.html { redirect_to :back, error: "Could not mark as featured." }
        format.js
      end
    end
  end

  def unmark_as_featured
    respond_to do |format|
      if @review.unmark_as_featured!
        format.html { redirect_to edit_psychic_path, notice: "Review successfully unmarked as featured." }
        format.js
      else
        format.html { redirect_to :back, error: "Could not unmark as featured." }
        format.js
      end
    end
  end

  protected

  def find_review
    redirect_to :root unless current_psychic

    @review = current_psychic.reviews.find(params[:id])
  end
end
