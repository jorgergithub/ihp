class Message
  include ActiveModel::Model

  attr_accessor :name, :email, :phone, :suggestions

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :suggestions, presence: true
end
