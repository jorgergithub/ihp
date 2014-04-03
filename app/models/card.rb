class Card < ActiveRecord::Base
  belongs_to :client

  self.inheritance_column = nil

  def to_s
    "#{type} ending in #{last4}"
  end
end
