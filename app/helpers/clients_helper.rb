module ClientsHelper
  def credit_card_icon(card)
    if card.type == "Visa"
      "visa"
    elsif card.type == "American Express"
      "american_express"
    elsif card.type == "MasterCard"
      "master_card"
    elsif card.type == "Discover"
      "discover"
    else
      "generic_2"
    end
  end
end