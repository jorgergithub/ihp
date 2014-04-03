class TrainingItem < ActiveRecord::Base
  has_many :psychic_training_items
  has_many :psychics, through: :psychic_training_items

  def reviewed?
    reviewed_at.present?
  end

  def reviewed!
    update_attributes reviewed_at: Time.zone.now
  end
end
