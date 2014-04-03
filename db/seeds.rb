# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)

class RandomHelper
  def self.phone
  "+1#{Faker::Base.regexify(/\d{10}/)}"
  end
end

ScheduleJob.create!(description: 'Client Weekly Usage Report',
                    week_day: 'monday',
                    at: '1AM',
                    model: 'ClientWeeklyUsageReport',
                    action: 'deliver')

horoscope = Horoscope.new(date: Date.today)
Horoscope::SIGNS.each do |sign|
  horoscope.send("#{sign.name.downcase}=", Faker::Lorem.paragraphs(3).join("\n"))
end
horoscope.lovescope = Faker::Lorem.paragraphs(3).join("\n")
horoscope.friendship_compatibility_from = Horoscope::SIGNS.sample.name
horoscope.friendship_compatibility_to = Horoscope::SIGNS.sample.name
horoscope.love_compatibility_from = Horoscope::SIGNS.sample.name
horoscope.love_compatibility_to = Horoscope::SIGNS.sample.name
horoscope.save

survey = Survey.create(name: "Client Survey", active: true)

question = survey.questions.create(type: "OptionsQuestion", text: "How often do you have a Psychic reading a month?")
question.options.create(text: "More than 10 times a month")
question.options.create(text: "6 - 10 times a month")
question.options.create(text: "2 - 5 times a month")
question.options.create(text: "Once a month")

question = survey.questions.create(type: "YesNoQuestion", text: "Do you currently use other Psychic services besides I Heart Psychics? ")

question = survey.questions.create(type: "OptionsQuestion", text: "How is your experience with I Heart Psychics versus the other Psychic services you have used?")
question.options.create(text: "Much Better")
question.options.create(text: "Better")
question.options.create(text: "The Same")
question.options.create(text: "Worst")
question.options.create(text: "Not Applicable")

question = survey.questions.create(type: "OptionsQuestion", text: "Based upon your experience with I Heart Psychics, how likely are you to use the service again?")
question.options.create(text: "Definitely Will")
question.options.create(text: "Probably Will")
question.options.create(text: "May or May Not")
question.options.create(text: "Probably Will Not")
question.options.create(text: "Definitely Will Not")

question = survey.questions.create(type: "TextQuestion", text: "Please share a few things that I Heart Psychics could do better to improve your experience:")

Package.create(id: 1, name: "70 for $60", credits: 70, price: 60, active: true, phone: true)
Package.create(id: 2, name: "95 for $80", credits: 95, price: 80, active: true, phone: true)
Package.create(id: 3, name: "120 for $99", credits: 120, price: 99, active: true, phone: true)

Tier.create(name: 'Bronze',   from: 0, to: 999, percent: 14)
Tier.create(name: 'Silver',   from: 1000, to: 1199, percent: 19)
Tier.create(name: 'Gold',     from: 1200, to: 1599, percent: 19.5)
Tier.create(name: 'Platinum', from: 1600, to: 1999, percent: 20)
Tier.create(name: 'Diamond',  from: 2000, to: 999999, percent: 21)

cat_general = Category.create(name: "General Questions")
cat_account = Category.create(name: "Account Questions")
cat_psychic = Category.create(name: "Psychic Questions")
cat_csr     = Category.create(name: "Customer Service")
cat_minutes = Category.create(name: "Adding Minutes")
cat_cancel  = Category.create(name: "Canceling Account")
cat_careers = Category.create(name: "Careers")

cat_general.faqs.create(question: "How do I call or chat with a Psychic?", answer: <<-EOS)
Simply select a psychic from the home page listings or browse psychic descriptions by category. If the psychic is available to take calls, you will see a “Call Me” button. If a psychic is available to chat you will see a “Chat Now” button. Click the psychic’s “Call Me” or “Chat Now” button to connect.

If you’re a first-time customer, you will be asked to set up an account before being connected. If you’re an existing customer, you must log in first to be connected with a psychic.
EOS

lorem = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Fugiat, dicta, eligendi, tempore sed maiores magni quibusdam libero quam quis ducimus voluptatum odio illum fuga excepturi aperiam totam iste ab temporibus."
cat_general.faqs.create(question: "What if my Psychic isn’t available?", answer: lorem)
cat_general.faqs.create(question: "What kind of question can I ask?", answer: lorem)
cat_general.faqs.create(question: "What if I run out of time during my
reading?", answer: lorem)
cat_general.faqs.create(question: "How will I know when I’m running
out of time?", answer: lorem)
cat_general.faqs.create(question: "Do I have to use my minutes all at
once?", answer: lorem)
cat_general.faqs.create(question: "What if I forget my 10-digit account
number or 4-digit PIN?", answer: lorem)

TrainingItem.create(title: "Welcome Message and Preparation for Your Shift", file: "/pdf/I HEART PSYCHICS - Welcome Message and Preparation for Your Shift.pdf")
TrainingItem.create(title: "Getting Setup", file: "/pdf/I HEART PSYCHICS - Getting Setup.pdf")
TrainingItem.create(title: "Important Startup Information", file: "/pdf/I HEART PSYCHICS - Important Startup Information.pdf")
TrainingItem.create(title: "Disclaimer and Policies", file: "/pdf/I HEART PSYCHICS - Disclaimer and Policies.pdf")
TrainingItem.create(title: "Our Mission Statement and Impact", file: "/pdf/I HEART PSYCHICS - Our Mission Statement and Impact.pdf")
TrainingItem.create(title: "Meet Our Customers", file: "/pdf/I HEART PSYCHICS - Meet Our Customers.pdf")
TrainingItem.create(title: "Do's and Don'ts", file: "/pdf/I HEART PSYCHICS - Dos and Donts.pdf")
TrainingItem.create(title: "Types of Callers", file: "/pdf/I HEART PSYCHICS - Types of Callers.pdf")
TrainingItem.create(title: "How to Begin a Reading", file: "/pdf/I HEART PSYCHICS - How to Begin a Reading.pdf")
TrainingItem.create(title: "Tips for Psychics", file: "/pdf/I HEART PSYCHICS - Tips for Psychics.pdf")
TrainingItem.create(title: "How We Differ from Other Networks", file: "/pdf/I HEART PSYCHICS - How We Differ From Other Networks.pdf")
TrainingItem.create(title: "Contact and Emergency Numbers", file: "/pdf/I HEART PSYCHICS - Contact and Emergency Numbers.pdf")

PageSeo.create(url: "/", page: "Home Page", title: "High Quality Live Phone Psychic Readings | I Heart Psychics", description: "I Heart Psychics is an innovative and simple platform that connects consumers to high quality readings, astrological, metaphysical and spiritual content.", keywords: "I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, psychic sofa, mediums, online tarot, free tarot reading online, psychics, free online tarot readings, psychic tv, free tarot readings, tarot on line, online tarot reading, psychic sally, psychic detective yakumo, tarot reading online, free physic reading, free love tarot reading, psychic medium")
# PageSeo.create(url: "/", page: "Special Offers", title: "Special Offers on Live Phone Psychic Readings | I Heart Psychics", description: "Special offers and deals for the lowest rates on the highest quality psychic readings with phenomenal customer service. Call 1-800-XXXXX to get started!", keywords: "I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, free tarot reading online, psychics, free online tarot readings, free tarot readings, psychic reading discount, psychic special offer, psychic reading special offer")
# PageSeo.create(url: "/", page: "Find a Psychic", title: "Find a Psychic to Connect With & Answer Your Questions | I Heart Psychics", description: "I Heart Psychics has hundreds of top-rated psychics to connect with for live psychic phone readings 24/7. Call 1-800-XXXXX to get started! ", keywords: "I Heart Psychics, iheartpsychics, iheartpsychics.co, psychics, psychic readings, phone psychics, tools, abilities, style, callbacks, appointments, style, price, tarot reading, psychic, clairvoyant, fortune teller, California psychics, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, free tarot reading online")
PageSeo.create(url: "/horoscopes", page: "Horoscopes", title: "Free Daily Horoscopes and Monthly Forecasts | I Heart Psychics", description: "View your free daily and monthly horoscopes today! Get your personalized horoscope delivered to your inbox from I Heart Psychics.", keywords: "horoscope, horoscopes, free horoscope, free horoscopes, daily horoscope, aries, taurus, gemini, cancer, leo, virgo, libra, scorpio, sagittarius, capricorn, aquarius, pisces, cusp, montly horoscope, I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics, tarot card reading, physic, tarot card meanings, psychic readings")
PageSeo.create(url: "/blog", page: "Blog", title: "Blog – Daily News, Advice and Guidance | I Heart Psychics", description: "Read the latest insights on all things related to astrological, metaphysical & spiritual content. Guidance & inspirational messages from top-rated psychics", keywords: "I Heart Psychics, iheartpsychics, iheartpsychics.co, psychics, psychic readings, phone psychics, live phone psychics, psychic blog, astrology blog, psychic writing, psychic advice, guidance, news, inspirational messages, motivational messages, inspiration blog, motivational blog, advice blog, horoscope writing")
PageSeo.create(url: "/about", page: "About IHP", title: "About Us – Learn more about our Psychic Service and Who We Are | I Heart Psychics", description: "Our innovative network combines the top psychic advisors and the latest technology to connect, advise, and help people just like you everyday, all day 24/7. ", keywords: "I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, psychic sofa, mediums, online tarot, free tarot reading online, psychics, free online tarot readings, psychic tv, free tarot readings, tarot on line, online tarot reading, psychic sally, psychic detective yakumo, tarot reading online, free physic reading, free love tarot reading, psychic medium")
PageSeo.create(url: "/faqs", page: "FAQs", title: "| I Heart Psychics", description: "When you’re not wondering about life’s questions, we have all the answers to the Frequently Asked Questions about the I Heart Psychics network.", keywords: "psychics, psychic readings, phone psychics, enlightenment, mediums, clairvoyant, tarot, astrology, dating and relationships, dream analysis, dream interpretation, compatibility, love advice, soulmate, soul mates, I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, fortune teller, california psychics, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, psychic sofa")
PageSeo.create(url: "/contact", page: "Contact IHP", title: "Contact Us | I Heart Psychics", description: "Have feedback or a question? Please contact us & submit your comments at IHeartPsychics.co. You can also sign up to receive our free horoscope & newsletter", keywords: "cntact, cotact, conact, contct, contat, contact is, contact su, I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, psychic sofa, mediums")
PageSeo.create(url: "/privacy", page: "Privacy Policy", title: "Privacy Policy | I Heart Psychics", description: "I Heart Psychics offers Live Psychic Readings by Phone, 24/7. Our Intuitive Psychics specialize in Love, Relationships, Career and Finance. Call 1-800-XXXX today!", keywords: "psychics, psychic readings, phone psychics, enlightenment, mediums, clairvoyant, tarot, astrology, dating and relationships, dream analysis, dream interpretation, compatibility, love advice, soulmate, soul mates, privacy policy, I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, psychic sofa, mediums")
PageSeo.create(url: "/terms", page: "Terms of Service", title: "Terms of Service | I Heart Psychics", description: "I Heart Psychics offers Live Psychic Readings by Phone, 24/7. Our Intuitive Psychics specialize in Love, Relationships, Career and Finance. Call 1-800-XXXX today!", keywords: "psychics, psychic readings, phone psychics, enlightenment, mediums, clairvoyant, tarot, astrology, dating and relationships, dream analysis, dream interpretation, compatibility, love advice, soulmate, soul mates, privacy policy, I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, psychic sofa, mediums")
PageSeo.create(url: "/dictionary", page: "IHP Dictionary", title: "Dictionary of Psychic, Astrological, Metaphysical and Spiritual Terms | I Heart Psychics", description: "Better understand the definitions and terms of Psychic, Astrological, Metaphysical and Spiritual world. Learn what tools and specialties each I Heart Psychic advisor concentrates on. ", keywords: "psychics, psychic readings, phone psychics, enlightenment, mediums, clairvoyant, tarot, astrology, dating and relationships, dream analysis, dream interpretation, compatibility, love advice, soulmate, soul mates, privacy policy, I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, psychic sofa, mediums")
PageSeo.create(url: "/careers", page: "IHP Careers", title: "Hiring & Recruiting the Best Psychics in the industry. Start your Career with Us!  | I Heart Psychics", description: "Apply to become apart of the I Heart Psychics network. Work full or part time from home as independent contractors and get paid weekly. Our top psychics can make over $1500 per week. Must be capable of delivering accurate and insightful psychic readings to our customers over the phone.", keywords: "psychic jobs, hiring psychics, psychics work from home, clairvoyants wanted, psychics wanted, are you psychic?, qualified psychics wanted, psychics wanted, are you psychic?,  top psychics, top psychics needed, Tarot Readers Wanted, Love Psychics Needed, California Psychics, Mediums Wanted, Accurate Readers, , I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, fortune teller, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, psychic sofa")
PageSeo.create(url: "/client", page: "Customer Dashboard", title: "Manage Your Account | I Heart Psychics", description: "Please login to your I Heart Psychics account. New visitors please register to receive your special offers on a reading today!", keywords: "psychic reading, psychic readings, customer, new customer, existing customer, karma rewards, I Heart Psychics Member login page, login, I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, fortune teller, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, psychic sofa")
PageSeo.create(url: "/psychic", page: "Psychic Dashboard", title: "Manage Your Psychic Account | I Heart Psychics", description: "", keywords: "I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, psychic sofa, mediums, online tarot, free tarot reading online, psychics, free online tarot readings, psychic tv, free tarot readings, tarot on line, online tarot reading, psychic sally, psychic detective yakumo, tarot reading online, free physic reading, free love tarot reading, psychic medium")
PageSeo.create(url: "/training_items", page: "Training | I Heart Psychics", title: "Training Videos & Employee Handbook | I Heart Psychics", description: "Receive training from the top psychic advisors in the industry and get an understanding of what is expected from you when you work with the I Heart Psychics network.", keywords: "psychic training, psychic jobs, hiring psychics, psychics work from home, clairvoyants wanted, psychics wanted, are you psychic?, qualified psychics wanted, psychics wanted, are you psychic?, top psychics, top psychics needed, Tarot Readers Wanted, Love Psychics Needed, California Psychics, Mediums Wanted, Accurate Readers, I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics")
# PageSeo.create(url: "/faqs", page: "FAQs (Psychics)", title: "| I Heart Psychics", description: "We are hiring psychics that are naturally gifted, have professional experience using their gift, and capable of delivering accurate and insightful readings over the phone. ", keywords: "frequently asked questions, FAQs, psychic jobs, hiring psychics, psychics work from home, clairvoyants wanted, psychics wanted, are you psychic?, qualified psychics wanted, psychics wanted, are you psychic?, top psychics, top psychics needed, Tarot Readers Wanted, Love Psychics Needed, California Psychics, Mediums Wanted, Accurate Readers, I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics")
# PageSeo.create(url: "/contact", page: "Contact IHP (Psychics)", title: "| I Heart Psychics", description: "We are hiring psychics that are naturally gifted, have professional experience using their gift, and capable of delivering accurate and insightful readings over the phone. ", keywords: "cntact, cotact, conact, contct, contat, contact is, contact su, I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics, tarot card reading, physic, psychic jobs, hiring psychics, psychics work from home, clairvoyants wanted, psychics wanted, are you psychic?, qualified psychics wanted, psychics wanted, are you psychic?, top psychics, top psychics needed, Tarot Readers Wanted, Love Psychics Needed, California Psychics, Mediums Wanted, Accurate Readers")
PageSeo.create(url: "", page: "All other pages", title: "High Quality Live Phone Psychic Readings | I Heart Psychics", description: "I Heart Psychics is an innovative and simple platform that connects consumers to high quality readings, astrological, metaphysical and spiritual content.", keywords: "I Heart Psychics, iheartpsychics, iheartpsychics.co, Psychic, tarot reading, psychic, clairvoyant, fortune teller, california psychics, tarot card reading, physic, tarot card meanings, psychic readings, free tarot card reading, free psychic reading, psychic source, psychic sofa, mediums, online tarot, free tarot reading online, psychics, free online tarot readings, psychic tv, free tarot readings, tarot on line, online tarot reading, psychic sally, psychic detective yakumo, tarot reading online, free physic reading, free love tarot reading, psychic medium")

admin = User.create!(first_name: 'Master', last_name: 'Admin',
                    username: 'adminn', email: 'admin@iheartpsychics.co',
                    password: 'ipass123', time_zone: "Eastern Time (US & Canada)",
                    create_as: 'admin', confirmed_at: Time.now)

wadmin = User.create!(first_name: 'Website', last_name: 'Admin',
                     username: 'wadmin', email: 'wadmin@iheartpsychics.co',
                     password: 'ipass123', create_as: 'website_admin',
                     time_zone: "Eastern Time (US & Canada)", confirmed_at: Time.now)

mdirector = User.create!(first_name: 'Manager', last_name: 'Director',
                        username: 'mdirrr', email: 'mdir@iheartpsychics.co',
                        password: 'ipass123', create_as: 'manager_director',
                        time_zone: "Eastern Time (US & Canada)", confirmed_at: Time.now)

accountant = User.create!(first_name: 'Accountant', last_name: '',
                         username: 'accountant', email: 'accountant@iheartpsychics.co',
                         password: 'ipass123', create_as: 'accountant',
                         time_zone: "Eastern Time (US & Canada)", confirmed_at: Time.now)

app1 = PsychicApplication.create!(first_name: 'Unfortunate', last_name: 'Teller', pseudonym: 'Ruffus',
                   username: 'ufteller', email: 'ufteller@iheartpsychics.co',
                   address: '3032 47th St', city: 'Lansing', state: 'MI', country: "United States",
                   postal_code: Faker::Address.zip_code,
                   password: 'ipass123', phone: '+17863295532',
                   cellular_number: '+13054502992',
                   date_of_birth: "1985-01-01",
                   emergency_contact: Faker::Name.name,
                   emergency_contact_number: "+13044440404",
                   us_citizen: true, has_experience: true,
                   experience: Faker::Lorem.paragraph,
                   gift: Faker::Lorem.words.join,
                   explain_gift: Faker::Lorem.paragraph,
                   age_discovered: 12,
                   reading_style: Faker::Lorem.paragraph,
                   why_work: Faker::Lorem.paragraph,
                   friends_describe: Faker::Lorem.paragraph,
                   strongest_weakest_attributes: Faker::Lorem.paragraph,
                   how_to_deal_challenging_client: Faker::Lorem.paragraph,
                   specialties: Faker::Lorem.paragraph,
                   tools: Faker::Lorem.paragraph,
                   professional_goals: Faker::Lorem.paragraph,
                   how_did_you_hear: 'Friend',
                   price: (3..9).to_a.sample,
                   time_zone: "Eastern Time (US & Canada)")

app2 = PsychicApplication.create!(first_name: 'Trinity', last_name: 'Megan', pseudonym: 'Magus',
                   username: 'tmegan', email: 'trinity@iheartpsychics.co',
                   address: '1022 32nd St', city: 'Miami', state: 'FL', country: "United States",
                   postal_code: Faker::Address.zip_code,
                   password: 'ipass123', phone: '+17863295532',
                   cellular_number: '+13054502993',
                   date_of_birth: "1985-01-01",
                   emergency_contact: Faker::Name.name,
                   emergency_contact_number: "+13044440404",
                   us_citizen: true, has_experience: true,
                   experience: Faker::Lorem.paragraph,
                   gift: Faker::Lorem.words.join,
                   explain_gift: Faker::Lorem.paragraph,
                   age_discovered: 12,
                   reading_style: Faker::Lorem.paragraph,
                   why_work: Faker::Lorem.paragraph,
                   friends_describe: Faker::Lorem.paragraph,
                   strongest_weakest_attributes: Faker::Lorem.paragraph,
                   how_to_deal_challenging_client: Faker::Lorem.paragraph,
                   specialties: Faker::Lorem.paragraph,
                   tools: Faker::Lorem.paragraph,
                   professional_goals: Faker::Lorem.paragraph,
                   how_did_you_hear: 'Friend',
                   price: (3..9).to_a.sample,
                   time_zone: "Eastern Time (US & Canada)")

app1.approve!
app2.approve!
# psy2.psychic.update_attributes phone: "+17863295532", about: "Trinity is descended from the Native Americans of the Lakota, Pima, and Navajo Indian tribes. Her psychic gifts have been passed down from generation to generation. An active proponent of her culture, Trinity regularly attends sacred pipe ceremonies and sweat lodges. After her brother's death in a tragic car accident, she became an actualized clairaudient. Determined to help others find closure and heal from unexpected loss, she began reading professionally. Trinity is also a clairvoyant who does not use tools. All she requires is a first name to channel messages from your Spirit Guides. Trinity specializes in love and relationships, and offers insights into diverse and unique interpersonal relationships, including polyamorous connections, among others. Raised with innate abilities, she conveys truthful and accurate messages, but she doesn't sugarcoat the information she receives.",
#   price: 6.5, address: "3044 74th Terrace", city: "Miami", state: "FL",
#   zip_code: "33143", cellular_number: "+13055053030", ssn: "3333333333",
#   date_of_birth: "1988-03-01", us_citizen: true, has_experience: true

csr = User.create!(first_name: 'Carlos', last_name: 'Taborda',
                  username: 'carlos', email: 'carlos@carlos.is',
                  password: 'ipass123', create_as: 'csr',
                  time_zone: "Eastern Time (US & Canada)",
                  confirmed_at: Time.now)

csr.rep.update_attributes phone: "+13054502995"

100.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  begin
    app = PsychicApplication.create!(first_name: first_name,
                               last_name: last_name,
                               pseudonym: Faker::Name.first_name,
                               username: Faker::Internet.user_name,
                               email: Faker::Internet.email(name: "#{first_name} #{last_name}"),
                               address: Faker::Address.street_address,
                               city: Faker::Address.city,
                               state: Faker::Address.state,
                               country: "United States",
                               postal_code: Faker::Address.zip_code,
                               password: 'ipass123',
                               phone: RandomHelper.phone,
                               cellular_number: "+1#{Faker::Base.regexify(/\d{10}/)}",
                               date_of_birth: "1985-01-01",
                               emergency_contact: Faker::Name.name,
                               emergency_contact_number: "+1#{Faker::Base.regexify(/\d{10}/)}",
                               us_citizen: true, has_experience: true,
                               experience: Faker::Lorem.paragraph,
                               gift: Faker::Lorem.words.join,
                               explain_gift: Faker::Lorem.paragraph,
                               age_discovered: 12,
                               reading_style: Faker::Lorem.paragraph,
                               why_work: Faker::Lorem.paragraph,
                               friends_describe: Faker::Lorem.paragraph,
                               strongest_weakest_attributes: Faker::Lorem.paragraph,
                               how_to_deal_challenging_client: Faker::Lorem.paragraph,
                               specialties: Faker::Lorem.paragraph,
                               tools: Faker::Lorem.paragraph,
                               professional_goals: Faker::Lorem.paragraph,
                               how_did_you_hear: 'Friend',
                               price: (3..9).to_a.sample,
                               time_zone: "Eastern Time (US & Canada)")
    app.approve!
  rescue ActiveRecord::RecordInvalid
    p $!.class
    p $!
    # raise $!
  end
end

Psychic.all.each do |p|
  p.update_attributes about: Faker::Lorem.paragraphs(3).join("\n")

  (0..(Random.rand(15))).each do |i|
    start_hour = (0..11).to_a.sample
    end_hour = (0..11).to_a.sample
    p.schedules.create(date: Date.today + i, start_time_string: "#{start_hour}:00 AM", end_time_string: "#{end_hour}:00 PM")
    if end_hour < 3
      start_hour = end_hour + Random.rand(3)
      end_hour = start_hour + Random.rand(3)
      p.schedules.create(date: Date.today + i, start_time_string: "#{start_hour}:00 AM", end_time_string: "#{end_hour}:00 PM")
    end
  end
end

user = User.new(first_name: "Felipe",
                   last_name: "Coury",
                   username: "fcoury",
                   email: "felipe.coury@gmail.com",
                   password: "ipass123",
                   role: "client",
                   time_zone: "Eastern Time (US & Canada)",
                   confirmed_at: Time.now)
client = user.build_client
client.balance = 250
client.birthday = Date.today
client.pin = "2244"
phone = client.phones.new
phone.number = "+17863295532"
user.save!

100.times do
  begin
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    user = User.new(first_name: first_name,
                       last_name: last_name,
                       username: Faker::Internet.user_name,
                       email: Faker::Internet.email(name: "#{first_name} #{last_name}"),
                       password: 'ipass123',
                       time_zone: "Eastern Time (US & Canada)",
                       confirmed_at: Time.now,
                       role: "client",
                       client_attributes: { birthday: Date.today })

    cli = user.build_client
    phone = cli.phones.new
    phone.number = RandomHelper.phone
    cli.balance = Random.rand(150)
    cli.birthday = Date.today
    user.save!
    # cli = user.client
    # p cli
    # cli.phones.create phone: Faker::PhoneNumber.phone_number
  rescue ActiveRecord::RecordInvalid
    p $!.class
    p $!
  end
end

now = DateTime.now
period_start = now - now.wday
period_end = period_start - 7.days

1000.times do
  psychic = Psychic.first(offset: rand(Psychic.count))
  client  = Client.first(offset: rand(Client.count))
  duration = Random.rand(240)
  original_duration = (duration * 60).to_s

  started_at = Time.at((period_end.to_f - period_start.to_f)*rand + period_start.to_f)
  ended_at = started_at + duration.minutes

  Call.create(client: client, psychic: psychic, original_duration: original_duration,
              started_at: started_at, ended_at: ended_at,
              start_time: started_at.to_s, ended_at: ended_at.to_s,
              cost: duration * psychic.price,
              cost_per_minute: psychic.price,
              from: client.phones.first.try(:number),
              processed: true)
end

psychic = User.find_by_username('tmegan').psychic
psychic.reviews.create(client: Client.first(offset: rand(Client.count)), rating: 5, text: "Amazing experience")
psychic.reviews.create(client: Client.first(offset: rand(Client.count)), rating: 4, text: "Super nice, recommended")

300.times do
  psychic = Psychic.first(offset: rand(Psychic.count))
  call = psychic.calls.all.sample
  psychic.reviews.create(call: call, client: call.client,
                         rating: 4, text: Faker::Lorem.words(10).join)
end
