class Faq < ActiveRecord::Base
  belongs_to :category

  validates :question, :answer, presence: true
end
