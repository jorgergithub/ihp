class Admin::AccountantsController < AuthorizedController
  before_filter :find_accountant

  def index
    @accountants = Accountant.accountants
      .order("users.first_name, users.last_name")
      .page(params[:page]).per(params[:per])
  end

  def new
    @accountant = Accountant.new(create_as: "accountant")
  end

  def edit
  end

  def create
    params = accountant_params.merge(create_as: "accountant")
    @accountant = Accountant.new(params)
    @accountant.skip_confirmation!
    if @accountant.save
      redirect_to admin_accountants_path,
        notice: "New accountant was successfully created."
    else
      render action: "edit"
    end
  end

  protected

  def find_accountant
    @accountant = Accountant.find(params[:id]) if params[:id]
  end

  def accountant_params
    params.require(:accountant).permit(:first_name, :last_name, :username,
                                       :email, :password, :time_zone)
  end
end
