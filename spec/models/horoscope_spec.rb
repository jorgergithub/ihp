require "spec_helper"

describe Horoscope do
  describe Horoscope::SIGNS do
    it "returns a list of signs" do
      expect(Horoscope::SIGNS).to be_eql([Sign::Aries,
                                          Sign::Taurus,
                                          Sign::Gemini,
                                          Sign::Cancer,
                                          Sign::Leo,
                                          Sign::Virgo,
                                          Sign::Libra,
                                          Sign::Sagittarius,
                                          Sign::Scorpio,
                                          Sign::Capricorn,
                                          Sign::Aquarius,
                                          Sign::Pisces
                                          ])
    end
  end

  describe ".last_by_date" do
    let!(:last_horoscope)   { FactoryGirl.create :horoscope, date: Date.today }
    let!(:first_horoscope)  { FactoryGirl.create :horoscope, date: Date.yesterday }
    subject { Horoscope }

    it "returns last horoscopes sorted by date" do
      expect(subject.last_by_date).to be_eql last_horoscope
    end
  end

  describe ".last_lovescope_horoscope" do
    let!(:first_lovescope_horoscope)  { FactoryGirl.create :horoscope, date: 3.days.ago, lovescope: "First Lovescope" }
    let!(:last_lovescope_horoscope)   { FactoryGirl.create :horoscope, date: 2.days.ago, lovescope: "Last Lovescope" }
    let!(:nil_lovescope_horoscope)    { FactoryGirl.create :horoscope, date: 1.day.ago,  lovescope: nil }
    let!(:empty_lovescope_horoscope)  { FactoryGirl.create :horoscope, date: Date.today, lovescope: "" }
    
    subject { Horoscope }

    it "returns last lovescope horoscope among horoscopes" do
      expect(subject.last_lovescope_horoscope).to be_eql last_lovescope_horoscope
    end
  end
end