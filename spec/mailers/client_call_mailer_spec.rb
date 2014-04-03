require "spec_helper"

describe ClientCallMailer do
  let!(:client)      { FactoryGirl.create(:client, balance: 10) }
  let!(:psychic)     { FactoryGirl.create(:psychic) }
  let!(:client_call) { FactoryGirl.create(:call, client: client,
                                                 psychic: psychic) }

  let(:host) { ActionMailer::Base.default_url_options[:host] }

  context "#client_call_statistics" do
    let(:email) { ClientCallMailer.client_call_statistics(client_call) }

    it "sends out the email to the client" do
      expect(email.to).to include(client.email)
    end

    it "sends out an email with the right subject" do
      subject = "I Heart Psychics - Your Call Summary With #{psychic.alias_name}"
      expect(email.subject).to include(subject)
    end

    it "sends out the duration of the call" do
      body = /Call Duration:(.*)2 minutes/
      expect(email.body.encoded).to match(body)
    end

    context "when call lasts 1 minute" do
      before { client_call.stub(duration: 1) }
      it "tells minutes in singular" do
        body = /Call Duration:(.*)1 minute/
        expect(email.body.encoded).to match(body)
      end
    end

    context "when client has credits left" do
      it "tells how much credits are left in client's balance" do
        body = /Current Balance:(.*)10/
        expect(email.body.encoded).to match(body)
      end
    end

    context "when client has no credits left" do
      pending "check if we need a link to add more credits here"
      # more here - https://basecamp.com/1799407/projects/2777704-iheart-psychics/messages/14347692-link-to-add-minutes

      # before { client.minutes = 0 }
      # it "informs the client that he's out of minutes" do
      #   body = "Your account is out of minutes."
      #   expect(email.body.encoded).to include(body)
      # end

      # it "shows link to add more minutes" do
      #   body = "To add more minutes, please visit #{add_minutes_client_url}"
      #   expect(email.body.encoded).to include(body)
      # end

      # it "adds a click here link in HTML" do
      #   body = "Please <a href=\"#{add_minutes_client_url}\">click here</a>"
      #   expect(email.body.encoded).to include(body)
      # end
    end
  end
end
