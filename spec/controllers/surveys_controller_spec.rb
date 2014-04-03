require "spec_helper"

describe SurveysController do
  let(:user) { create(:user, create_as: "client") }
  let(:client) { user.client }
  let(:call) { create(:call, client: client) }

  before {
    user.confirm!
    sign_in user
  }

  describe "GET show" do
    let!(:survey) { create(:survey, active: true) }

    context "with a new survey" do
      before { get :show, id: call.id }

      it "shows the survey for the call" do
        expect(assigns[:survey]).to eql(survey)
      end
    end

    context "with a survey that's already completed" do
      before {
        call.build_call_survey
        call.save
        get :show, id: call.id
      }

      it "redirects back to the client path" do
        expect(response).to redirect_to(client_path)
      end

      it "shows an error message" do
        expect(flash[:error]).to eql("You already completed this survey.")
      end
    end

  end

  describe "POST answer" do
    let(:survey) { create(:survey) }
    let(:call_survey) { create(:call_survey, call: call, survey: survey) }

    def post_answers
      post :answer, id: call.id, review: { rating: "4", text: "something" },
        call_survey: {
          answers: { "1" => {text: "first_answer"},
                     "2" => {text: "Yes"},
                     "3" => {option_id: "2"} }
        }
    end

    before { post_answers }

    context "when saved" do
      it "redirects to client_path" do
        expect(response).to redirect_to(client_path)
      end

      it "adds a flash message" do
        expect(flash[:notice]).to eql("Your survey results were saved successfully.")
      end
    end

    context "when submitted twice" do
      before { post_answers }

      it "redirects to client_path" do
        expect(response).to redirect_to(client_path)
      end

      it "displays an error message" do
        expect(flash[:error]).to eql("You already completed this survey.")
      end
    end
  end
end
