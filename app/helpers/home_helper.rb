module HomeHelper
  def container_offer_modal_id
    return "select_payment_method_modal" if @client
    return "sign_up_modal" unless current_user
  end
end