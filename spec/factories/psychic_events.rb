# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :psychic_event do
    psychic nil
    state "MyString"
  end
end
