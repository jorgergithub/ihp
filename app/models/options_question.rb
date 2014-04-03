class OptionsQuestion < Question
  has_many :options, :class_name => "Option", :foreign_key => "question_id", dependent: :destroy
  accepts_nested_attributes_for :options, :allow_destroy => true
end
