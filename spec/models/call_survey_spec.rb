require 'spec_helper'

describe CallSurvey do
  describe "#build_answers" do
    let(:survey) { FactoryGirl.create(:survey) }
    let(:call_survey) { FactoryGirl.build(:call_survey, survey: survey) }

    before { call_survey.build_answers }

    it "creates one answer entry per question on the survey" do
      expect(call_survey.answers.size).to eql(3)
    end

    it "creates one answer for the first question" do
      expect(call_survey.answers.first.question).to eql(survey.questions.first)
    end

    it "creates one answer for the second question" do
      expect(call_survey.answers.second.question).to eql(survey.questions.second)
    end

    it "creates one answer for the last question" do
      expect(call_survey.answers.last.question).to eql(survey.questions.last)
    end
  end
end
