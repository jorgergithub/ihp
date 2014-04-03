# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :psychic_faq do
    psychic_faq_category nil
    question "MyText"
    answer "MyText"
    order 1
  end
end
