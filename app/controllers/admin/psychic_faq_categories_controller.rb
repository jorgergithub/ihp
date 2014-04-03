class Admin::PsychicFaqCategoriesController < AuthorizedController
  before_action :find_psychic_faq_category

  def index
    @categories = PsychicFaqCategory.order(:name).page(params[:page]).per(params[:per])
  end

  def new
    @category = PsychicFaqCategory.new
  end

  def edit
  end

  def create
    @category = PsychicFaqCategory.new(category_params)

    if @category.save
      redirect_to admin_psychic_faq_categories_path, notice: "FAQ Category was successfully created."
    else
      render action: "edit"
    end
  end

  def update
    if @category.update_attributes(category_params)
      redirect_to admin_psychic_faq_categories_path, notice: "FAQ Category was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_psychic_faq_categories_path, notice: 'FAQ Category was successfully deleted.'
  end

  protected

  def category_params
    params.require(:psychic_faq_category).permit(
      :name, faqs_attributes: [:id, :question, :answer, :_destroy]
    )
  end

  def find_psychic_faq_category
    @category = PsychicFaqCategory.find(params[:id]) if params[:id]
  end
end
