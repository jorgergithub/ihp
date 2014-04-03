class Transaction < ActiveRecord::Base
  include I18n::Alchemy

  belongs_to :client
  belongs_to :order

  def parsed_time_only
    created_at.strftime("%I:%M %p")
  end

  def parsed_date_only
    created_at.strftime("%b %d, %Y")
  end
end
