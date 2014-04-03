class Admin::PackagesController < AuthorizedController
  before_filter :find_package

  def index
    @packages = Package.order(:id).page(params[:page]).per(params[:per])
  end

  def new
    @package = Package.new
  end

  def edit
  end

  def create
    @package = Package.new(package_params)
    if @package.save
      redirect_to admin_packages_path, notice: "New package was successfully created."
    else
      render action: "edit"
    end
  end

  def update
    if @package.update_attributes(package_params)
      redirect_to admin_packages_path, notice: "Package was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    begin
      @package.destroy
      redirect_to admin_packages_path, notice: "Package was successfully deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Can't delete package with orders"
      redirect_to admin_packages_path
    end
  end

  protected

  def find_package
    @package = Package.find(params[:id]) if params[:id]
  end

  def package_params
    params.require(:package).permit(:name, :credits, :price, :active, :phone)
  end
end
