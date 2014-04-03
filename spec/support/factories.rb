FactoryGirl.define do
  sequence :email do |n|
    "john#{n}@doe.com"
  end

  sequence :username do |n|
    "johndoe#{n}"
  end

  factory :user do
    first_name "John"
    last_name "Doe"
    email { generate(:email) }
    username { generate(:username) }
    password "testpass"
    time_zone "Eastern Time (US & Canada)"
  end

  factory :admin, parent: :user do
    role "admin"
  end

  factory :wadmin, parent: :user do
    role "website_admin"
  end

  factory :psychic_user, parent: :user do
    create_as "psychic"
  end

  factory :client_phone do
    desc "Main"
    number { "+1#{rand(1000000000...9999999999)}" }
  end

  factory :client do
    association :user
    balance 60
    birthday Date.today
    pin "1234"
    phones { [FactoryGirl.create(:client_phone)] }
  end

  factory :psychic do
    association :user, factory: :psychic_user
    pseudonym "Jack"
    phone "+15186335473"
    price "4.50"

    after(:create) do |psychic, evaluator|
      user = psychic.user
      user.psychic = psychic
      user.save
    end
  end

  factory :psychic_application do
    first_name 'Unfortunate'
    last_name 'Teller'
    username 'ufteller'
    email 'ufteller@iheartpsychics.co'
    pseudonym 'Ruffus'
    address '3032 47th St'
    city 'Lansing'
    country 'United States'
    state 'MI'
    postal_code { Faker::Address.zip_code }
    password 'ipass123'
    phone '+17863295531'
    cellular_number '+13054502992'
    date_of_birth "1985-01-01"
    emergency_contact { Faker::Name.name }
    emergency_contact_number "+13044440404"
    us_citizen true
    has_experience true
    experience { Faker::Lorem.paragraph }
    gift { "Empathy Medium" }
    explain_gift { Faker::Lorem.paragraph }
    age_discovered 12
    reading_style { Faker::Lorem.paragraph }
    why_work { Faker::Lorem.paragraph }
    friends_describe { Faker::Lorem.paragraph }
    strongest_weakest_attributes { Faker::Lorem.paragraph }
    how_to_deal_challenging_client { Faker::Lorem.paragraph }
    specialties { "Love and relationships" }
    tools { Faker::Lorem.paragraph }
    professional_goals { Faker::Lorem.paragraph }
    how_did_you_hear 'Other'
    other { Faker::Lorem.paragraph }
    resume { File.open("#{Rails.root}/spec/fixtures/example_resume.pdf") }
    price { 2 }
    time_zone { "Eastern Time (US & Canada)" }
  end

  factory :review do
    association :client
    association :psychic
    association :call
    rating 5
    text "I'm in love"

    factory :featured_review do
      featured true
    end
  end

  factory :package do
    name "Credits Package"
    credits 10
    price "9.99"
  end

  factory :call do
    sid "CAc1ffa7a744d25480e5ee009dfd7b2fc4"
    association :client
    association :psychic
    date_created "Wed, 17 Jul 2013 23:50:32 +0000"
    date_updated "Wed, 17 Jul 2013 23:51:57 +0000"
    account_sid "AC4d5e48e4d4647262b5c4314e36e3d26e"
    to "+15186335473"
    from "+17863295532"
    phone_number_sid "PN9523396e26f2d67f4375b7c67599a191"
    status "completed"
    start_time "Wed, 17 Jul 2013 23:50:32 +0000"
    end_time "Wed, 17 Jul 2013 23:51:57 +0000"
    original_duration "85"
    price "-0.02000"
    price_unit "USD"
    direction "inbound"
    answered_by nil
    caller_name nil
    uri "/2010-04-01/Accounts/AC4d5e48e4d4647262b5c4314e36e3d26e/Calls/CAc1ffa7a744d25480e5ee009dfd7b2fc4.json"
    processed nil
    created_at "2013-08-08 13:55"

    factory :processed_call do
      processed true
    end
  end

  factory :order do
    association :client
    payment_method "credit_card"
    total "9.99"
    status nil
  end

  factory :order_item do
    association :order
    association :package
    description "MyString"
    qty 1
    unit_price "9.99"
    total_price "9.99"
  end

  factory :survey do
    name "Client Survey"
    active true

    after(:create) do |survey, ev|
      FactoryGirl.create(:text_question, survey_id: survey.id)
      FactoryGirl.create(:yes_no_question, survey_id: survey.id)
      FactoryGirl.create(:options_question, survey_id: survey.id)
    end
  end

  factory :text_question, class: "TextQuestion" do
    text "Describe how was your life so far"
  end

  factory :yes_no_question, class: "YesNoQuestion" do
    text "Do you like it?"
  end

  factory :options_question, class: "OptionsQuestion" do
    text "How often do you?"

    after(:create) do |q, ev|
      FactoryGirl.create(:option, question_id: q.id, text: "Very Often")
      FactoryGirl.create(:option, question_id: q.id, text: "Often")
      FactoryGirl.create(:option, question_id: q.id, text: "Not that often")
      FactoryGirl.create(:option, question_id: q.id, text: "Rarely")
      FactoryGirl.create(:option, question_id: q.id, text: "Never")
    end
  end

  factory :option do
    text "Option text"
  end

  factory :call_survey do
    association :call
    association :survey
  end

  factory :newsletter do
    title "Weekly I Heart Psychics newletter"
    body "<p><span style=\"font-size:22px\"><strong>Newsletter</strong></span></p>"
    deliver_by "2013-08-18"
    created_at "2013-08-16 17:20:16"
    updated_at "2013-08-20 01:29:56"
  end

  factory :invoice do
    psychic
    total_minutes 0
    number_of_calls 1
    avg_minutes 13.2
    minutes_payout 154.0
    bonus_payout 9.8
    tier_id 1
    bonus_minutes 140
    total 163.8
  end

  factory :schedule do
    psychic
    date Date.today.in_time_zone.to_date
    start_time Time.now
    end_time Time.now + 8.hours
  end

  factory :callback do
    psychic
    client
    wait_for 30
    status "active"
  end

  factory :horoscope do
    date Date.today
    aries "aries Horoscope"
    taurus "taurus Horoscope"
    gemini "gemini Horoscope"
    cancer "cancer Horoscope"
    leo "leo Horoscope"
    virgo "virgo Horoscope"
    libra "libra Horoscope"
    scorpio "scorpio Horoscope"
    sagittarius "sagittarius Horoscope"
    capricorn "capricorn Horoscope"
    aquarius "aquarius Horoscope"
    pisces "pisces Horoscope"

    friendship_compatibility_from "Aries"
    friendship_compatibility_to "Taurus"
    love_compatibility_from "Virgo"
    love_compatibility_to "Capricorn"

    lovescope ""
  end

  factory :sign do
    name "Aries"
    first_date Date.new(2014,3,21)
    last_date Date.new(2014,4,19)
  end

  factory :training_item do
    title "Some Training"
    file "some_training.pdf"
  end

  factory :page_seo do
    page "My Page"
    url "/my_page"
    title "My Title"
    description "My Description"
    keywords "My Keywords"
  end
end
