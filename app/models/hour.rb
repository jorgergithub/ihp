class Hour < ActiveRecord::Base
  belongs_to :psychic
  belongs_to :call

  def start?
    action == "start"
  end
end
