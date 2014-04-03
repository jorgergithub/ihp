class Answer < ActiveRecord::Base
  belongs_to :call_survey
  belongs_to :question

  def answer
    text || question.options.find(option_id).try(:text)
  end
end
