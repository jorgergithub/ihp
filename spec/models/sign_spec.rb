require "spec_helper"

describe Sign do
  let(:horoscope) { FactoryGirl.build :horoscope }
  let(:subject)   { Sign::Taurus }

  it "delegates :text to horoscope" do
    horoscope.taurus = "Taurus Horoscope"
    subject.horoscope = horoscope
    expect(subject.text).to be_eql "Taurus Horoscope"
  end

  describe ".by_date" do
    Horoscope::SIGNS.each do |sign|
      it "returns #{sign.name} from a given date" do
        expect(Sign.by_date(sign.first_day).name).to be_eql sign.name
        expect(Sign.by_date(sign.last_day).name).to be_eql sign.name
      end
    end
  end
end