class CustomerServiceRepresentativesController < AuthorizedController
  before_filter :find_csr, except: [:new]

  def show
  end

  def update
    if @csr.localized.update_attributes(csr_params)
      redirect_to dashboard_path, notice: "CSR was successfully updated."
    else
      render action: "show"
    end
  end

  protected

  def find_csr
    @csr = current_csr.localized
  end

  def csr_params
    params.require(:customer_service_representative).permit(:phone, :available)
  end
end
