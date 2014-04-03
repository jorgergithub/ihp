class Review < ActiveRecord::Base
  belongs_to :call
  belongs_to :client
  belongs_to :psychic

  delegate :full_name, to: :client, allow_nil: true, prefix: true
  delegate :reviews, to: :psychic, allow_nil: true, prefix: true

  validates :client, :psychic, :call, :rating, :text, presence: true

  scope :featured, -> { where(featured: true) }
  scope :regular, -> { where(featured: false) }

  Ratings = {
    5 => "Woohoo! As good as it gets!",
    4 => "Yay! I'm a fan.",
    3 => "Not bad, not great. Average.",
    2 => "Meh. I've had better.",
    1 => "Eek! I think not."
  }

  def mark_as_featured!
    update_attribute(:featured, true)
  end

  def unmark_as_featured!
    update_attribute(:featured, false)
  end
end
