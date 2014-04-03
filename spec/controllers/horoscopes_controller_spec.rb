require 'spec_helper'

describe HoroscopesController do
  describe "GET 'index'" do
    let!(:first_horoscope)      { FactoryGirl.create :horoscope, date: Date.yesterday }
    let!(:last_horoscope)       { FactoryGirl.create :horoscope, date: Date.today }
    let!(:lovescope_horoscope)  { FactoryGirl.create :horoscope, date: 2.days.ago, lovescope: "Love the capricornians" }

    it "assigns last horoscope by date" do
      get :index
      expect(assigns[:horoscope]).to be_eql last_horoscope
    end

    it "assigns last horoscope with lovescope" do
      get :index
      expect(assigns[:lovescope_horoscope]).to be_eql lovescope_horoscope
    end
  end
end
