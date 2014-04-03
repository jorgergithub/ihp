require "spec_helper"

describe Callback do
  it { should belong_to :psychic }
  it { should belong_to :client }

  describe "#expired?" do
    before { Timecop.freeze(Time.zone.parse("2013-09-28 00:00")) }
    after { Timecop.return }

    it "is false if expires_at is in the future" do
      subject.expires_at = Time.now + 1.second
      expect(subject).to_not be_expired
    end

    it "is true if expires_at is in the past" do
      subject.expires_at = Time.now - 1.second
      expect(subject).to be_expired
    end

    it "is true if expires_at is now" do
      subject.expires_at = Time.now
      expect(subject).to be_expired
    end

    it "is false if expires_at is null" do
      subject.expires_at = nil
      expect(subject).to_not be_expired
    end
  end

  describe "#time_for" do
    before { Timecop.freeze(Time.zone.parse("2013-09-28 00:00")) }
    after { Timecop.return }

    it "sets the expired_at" do
      subject.wait_for = 10
      expect(subject.expires_at).to eql(Time.now.in_time_zone + 10.minutes)
    end

    it "sets the expired_at to nil if nil" do
      subject.wait_for = nil
      expect(subject.expires_at).to be_nil
    end

    it "returns the number of minutes left" do
      subject.expires_at = Time.now.in_time_zone + 5.minutes + 30.seconds
      expect(subject.wait_for).to eql(5)
    end

    it "returns nil if expires_at is nil" do
      subject.expires_at = nil
      expect(subject.wait_for).to be_nil
    end

    it "converts from string" do
      subject.wait_for = "15"
      expect(subject.expires_at).to eql(Time.now.in_time_zone + 15.minutes)
    end
  end

  describe "#update_status" do
    it "changes the status" do
      subject.update_status "finished"
      expect(subject.status).to eql("finished")
    end
  end

  describe "#cancel_by_psychic" do
    before {
      subject.stub(:handle_psychic_cancellation)
      subject.cancel_by_psychic
    }

    it "calls handle_psychic_cancellation" do
      expect(subject).to have_received(:handle_psychic_cancellation)
    end

    it "changes the status to cancelled_by_psychic" do
      expect(subject.status).to eql("cancelled_by_psychic")
    end
  end

  describe "#handle_psychic_cancellation" do
    context "when there is a client call" do
      let(:call_script) { double(:call_script) }

      before {
        subject.stub(client_call_sid: "CLIENT_CALL")
        subject.stub(client_call_url: "CLIENT_CALL_URL")
        subject.stub(:modify_call)

        call_script.stub(:advance_to)
        CallScript.stub(for: call_script)

        subject.handle_psychic_cancellation
      }

      it "retrieves the call script for the client call" do
        expect(CallScript).to have_received(:for).with("CLIENT_CALL")
      end

      it "changes the call script status" do
        expect(call_script).to have_received(:advance_to).with("psychic_cancelled")
      end

      it "modifies the live call" do
        expect(subject).to have_received(:modify_call).with("CLIENT_CALL", "CLIENT_CALL_URL")
      end
    end
  end

  describe "#cancel_by_client" do
    before {
      subject.stub(:handle_client_cancellation)
      subject.cancel_by_client
    }

    it "calls handle_client_cancellation" do
      expect(subject).to have_received(:handle_client_cancellation)
    end

    it "changes the status to cancelled_by_client" do
      expect(subject.status).to eql("cancelled_by_client")
    end
  end

  describe "#handle_client_cancellation" do
    context "when there is a psychic call" do
      let(:call_script) { double(:call_script) }

      before {
        subject.stub(psychic_call_sid: "PSYCHIC_CALL")
        subject.stub(psychic_call_url: "PSYCHIC_CALL_URL")
        subject.stub(:modify_call)

        call_script.stub(:advance_to)
        CallScript.stub(for: call_script)

        subject.handle_client_cancellation
      }

      it "retrieves the call script for the client call" do
        expect(CallScript).to have_received(:for).with("PSYCHIC_CALL")
      end

      it "changes the call script status" do
        expect(call_script).to have_received(:advance_to).with("client_cancelled")
      end

      it "modifies the live call" do
        expect(subject).to have_received(:modify_call).with("PSYCHIC_CALL", "PSYCHIC_CALL_URL")
      end
    end
  end

  describe "#finish" do
    let(:user1) { create(:user, create_as: "client", first_name: "Felipe", last_name: "Coury") }
    let(:client) { user1.client }

    let(:user2) { create(:user, create_as: "psychic", first_name: "Mike", last_name: "Vid") }
    let(:psychic) { user2.psychic }

    let(:callback) { create(:callback, client: client, psychic: psychic) }
  end

  describe "#execute" do
    it "calls the psychic and redirects to the PsychicCallbacksController index" do

    end
  end
end
