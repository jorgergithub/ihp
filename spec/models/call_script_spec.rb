require "spec_helper"

describe CallScript do
  describe "#context" do
    let(:context) { double(:context, params: { Digits: "1", id: "123" }) }

    subject { CallScript.new(context: context) }

    it "sets the digits" do
      expect(subject.context.digits).to eql("1")
    end

    it "sets the params hash" do
      expect(subject.context.params).to eql({ Digits: "1", id: "123" })
    end
  end

  describe "#process" do
    let(:context) { double(:context, params: { Digits: "2", id: "123"} ) }
    let(:response) { double(:response) }

    context "when next_action is nil" do
      subject { CallScript.new(context: context, next_action: nil) }

      before {
        subject.stub(initial_state: response)
        @response = subject.process(context)
      }

      it "sets the context params" do
        expect(subject.context.params).to eql({ Digits: "2", id: "123" })
      end

      it "sets the context digits" do
        expect(subject.context.digits).to eql("2")
      end

      it "calls the initial_state" do
        expect(subject).to have_received(:initial_state)
      end

      it "returns the response" do
        expect(@response).to eql(response)
      end
    end

    context "when next_action is set" do
      subject { CallScript.new(context: context, next_action: "action_name") }

      before {
        subject.stub(action_name: response)
        @response = subject.process(context)
      }

      it "calls the method name in next_action" do
        expect(subject).to have_received(:action_name)
      end
    end
  end

  describe "#send_menu" do
    let(:context) { double(:context, params: { Digits: "1", id: "123" }) }
    let(:menu_options) { { "1" => "this", "2" => "that" } }
    let!(:response) { subject.send_menu("Hey", menu_options)}

    subject { CallScript.new(context: context) }

    it "sets the next action as process_menu_result" do
      expect(subject.next_action).to eql("process_menu_result")
    end

    it "sets the params for menu_options" do
      expect(subject.params[:menu_options]).to eql({ "1" => "this", "2" => "that" })
    end

    it "returns the generated TwiML" do
      expect(response).to include("<Say>Hey</Say>")
    end

    it "uses the maximum number of digits" do
      expect(response).to include("<Gather numDigits=\"1\">")
    end

    context "with larger digits" do
      let(:menu_options) { { "1" => "this", "20" => "that" } }

      it "uses the finishOnKey param to be set" do
        expect(response).to include("<Gather finishOnKey=\"#\">")
      end
    end
  end

  describe "#process_menu_result" do
    let(:context) { double(:context, params: { Digits: "1", id: "123" }) }

    subject { CallScript.new(context: context) }

    before {
      subject.send_menu("Hey", { "1" => "action1", "2" => "action2" })
      subject.stub(:process)
    }

    let!(:response) { subject.process_menu_result }

    it "sets the next_action to the param" do
      expect(subject.next_action).to eql("action1")
    end

    it "processes the result" do
      expect(subject).to have_received(:process)
    end

    context "with invalid option" do
      let(:context) { double(:context, params: { Digits: "8", id: "123" }) }

      it "sends an error response" do
        expect(response).to match(/The option you selected is invalid./)
      end

      it "tells the available options" do
        expect(response).to match(/Please enter 1 or 2/)
      end
    end
  end
end
