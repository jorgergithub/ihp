class Package < ActiveRecord::Base
  scope :active, -> { where("active").order("credits DESC") }
  scope :phone_offers, -> { active.where("phone").order("credits DESC") }
  has_many :order_items, dependent: :restrict_with_exception

  validates_presence_of :name, :price, :credits

  def discount
    (100 - ((price / credits) * 100)).round
  end
end
