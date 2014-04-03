class Survey < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, :allow_destroy => true
  has_many :answers, through: :questions
  has_many :call_surveys

  scope :actives, -> { where('active') }

  def self.active
    actives.take
  end
end
