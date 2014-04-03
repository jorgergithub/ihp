class Application
  include ActiveModel::Model

  attr_accessor :first_name, :last_name
  attr_accessor :email, :phone, :position
  attr_accessor :attachment
  attr_accessor :comments

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :email,      presence: true
  validates :phone,      presence: true
  validates :position,   presence: true
  validates :attachment, presence: true
  validates :comments,   presence: true
end
