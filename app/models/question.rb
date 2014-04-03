class Question < ActiveRecord::Base
  belongs_to :survey, polymorphic: :true
  has_one :answer
end
