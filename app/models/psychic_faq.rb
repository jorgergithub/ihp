class PsychicFaq < ActiveRecord::Base
  belongs_to :psychic_faq_category

  validates :question, :answer, presence: true
end
