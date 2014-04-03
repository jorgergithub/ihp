class Admin::CategoriesController < AuthorizedController
  before_action :find_category

  def index
    @categories = Category.order(:name).page(params[:page]).per(params[:per])
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "FAQ Category was successfully created."
    else
      render action: "edit"
    end
  end

  def update
    if @category.update_attributes(category_params)
      redirect_to admin_categories_path, notice: "FAQ Category was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: 'FAQ Category was successfully deleted.'
  end

  protected

  def category_params
    params.require(:category).permit(
      :name, faqs_attributes: [:id, :question, :answer, :_destroy]
    )
  end

  def find_category
    @category = Category.find(params[:id]) if params[:id]
  end
end
