class PsychicEvent < ActiveRecord::Base
  belongs_to :psychic

  validates :psychic, :state, presence: true
end
