class AccountantsController < AuthorizedController
  before_filter :find_accountant, except: [:new]

  def show
  end

  def update
    if @accountant.localized.update_attributes(accountant_params)
      redirect_to dashboard_path, notice: "CSR was successfully updated."
    else
      render action: "show"
    end
  end

  protected

  def find_accountant
    @accountant = current_accountant.localized
  end

  def accountant_params
    params.require(:accountant).permit(:phone, :available)
  end
end
