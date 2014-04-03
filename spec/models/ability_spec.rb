require "spec_helper"
require "cancan/matchers"

describe Ability do
  let(:user)             { FactoryGirl.create(:user) }
  let(:client)           { FactoryGirl.create(:user, create_as: "client") }
  let(:admin)            { FactoryGirl.create(:user, create_as: "admin") }
  let(:website_admin)    { FactoryGirl.create(:user, create_as: "website_admin") }
  let(:psychic)          { FactoryGirl.create(:user, create_as: "psychic") }
  let(:csr)              { FactoryGirl.create(:user, create_as: "csr") }
  let(:manager_director) { FactoryGirl.create(:user, create_as: "manager_director") }
  let(:accountant)       { FactoryGirl.create(:user, create_as: "accountant") }

  describe "as a guest" do
    subject { Ability.new(nil) }

    it "can access home" do
      subject.should be_able_to(:access, :home)
    end

    it "can access horoscopes" do
      subject.should be_able_to(:access, :horoscopes)
    end

    it "can sign in" do
      subject.should be_able_to(:create, "devise/sessions")
    end

    it "can sign up" do
      subject.should be_able_to(:create, :registrations)
    end

    it "can apply as a psychic" do
      subject.should be_able_to(:create, :psychic_applications)
    end

    it "can't sign out" do
      subject.should_not be_able_to(:destroy, "devise/sessions")
    end

    it "can post to paypal callback" do
      subject.should be_able_to(:callback, :paypal)
    end

    it "can post to psychic callback" do
      subject.should be_able_to(:create, "calls/psychic_callbacks")
    end

    it "can post to client callback" do
      subject.should be_able_to(:create, "calls/client_callbacks")
    end
  end

  describe "as any user" do
    subject { Ability.new(user) }

    it "can sign out" do
      subject.should be_able_to(:destroy, "devise/sessions")
    end
  end

  describe "as a client" do
    subject { Ability.new(client) }

    it "can update profile" do
      subject.should be_able_to(:update, :clients)
    end

    it "can delete card" do
      subject.should be_able_to(:destroy_card, :clients)
    end

    it "can edit profile" do
      subject.should be_able_to(:edit, :clients)
    end

    it "can show profile" do
      subject.should be_able_to(:show, :clients)
    end

    it "can reset pin" do
      subject.should be_able_to(:reset_pin, :clients)
    end

    it "can make a psychic favorite" do
      subject.should be_able_to(:make_favorite, :clients)
    end

    it "can remove a favorite psychic" do
      subject.should be_able_to(:remove_favorite, :clients)
    end

    it "can add new callback" do
      subject.should be_able_to(:new, :callbacks)
    end

    it "can't create a new client" do
      subject.should_not be_able_to(:new, :clients)
      subject.should_not be_able_to(:create, :clients)
    end

    it "can't destroy a client" do
      subject.should_not be_able_to(:destroy, :clients)
    end

    it "can create a new order" do
      subject.should be_able_to(:new, :orders)
      subject.should be_able_to(:create, :orders)
    end

    it "can view an order" do
      subject.should be_able_to(:show, :orders)
    end

    it "can't update an order" do
      subject.should_not be_able_to(:update, :orders)
    end

    it "can't destroy an order" do
      subject.should_not be_able_to(:destroy, :orders)
    end

    it "search for psychics" do
      subject.should be_able_to(:search, :psychics)
    end

    it "talk about a psychic" do
      subject.should be_able_to(:about, :psychics)
    end

    it "can create, retrive, update and delete phones" do
      subject.should be_able_to(:access, :client_phones)
    end
  end

  describe "as an admin" do
    subject { Ability.new(admin) }

    it "can access admin dashboards" do
      subject.should be_able_to(:access, "admin/dashboards")
    end

    it "can access admin psychics" do
      subject.should be_able_to(:access, "admin/psychics")
    end

    it "can access admin clients" do
      subject.should be_able_to(:access, "admin/clients")
    end

    it "can access admin packages" do
      subject.should be_able_to(:access, "admin/packages")
    end

    it "can access admin customer_service_representatives" do
      subject.should be_able_to(:access, "admin/customer_service_representatives")
    end

    it "can access admin manager_directors" do
      subject.should be_able_to(:access, "admin/manager_directors")
    end

    it "can access admin website_admins" do
      subject.should be_able_to(:access, "admin/website_admins")
    end

    it "can access admin accountants" do
      subject.should be_able_to(:access, "admin/accountants")
    end

    it "can access admin schedule_jobs" do
      subject.should be_able_to(:access, "admin/schedule_jobs")
    end
  end

  describe "as a website admin" do
    subject { Ability.new(website_admin) }

    it "can access admin dashboards" do
      subject.should be_able_to(:access, "admin/dashboards")
    end

    it "can access admin psychics" do
      subject.should be_able_to(:access, "admin/psychics")
    end

    it "can access admin clients" do
      subject.should be_able_to(:access, "admin/clients")
    end

    it "can access admin packages" do
      subject.should be_able_to(:access, "admin/packages")
    end

    it "can access admin orders" do
      subject.should be_able_to(:access, "admin/orders")
    end

    it "can access admin surveys" do
      subject.should be_able_to(:access, "admin/surveys")
    end

    it "can access admin categories" do
      subject.should be_able_to(:access, "admin/categories")
    end

    it "can access admin horoscopes" do
      subject.should be_able_to(:access, "admin/horoscopes")
    end

    it "can access admin newsletters" do
      subject.should be_able_to(:access, "admin/newsletters")
    end
  end

  describe "as a psychic" do
    subject { Ability.new(psychic) }

    it "can access psychics" do
      subject.should be_able_to(:access, :psychics)
    end

    it "can access schedules" do
      subject.should be_able_to(:access, :invoices)
    end

    it "can access invoices" do
      subject.should be_able_to(:access, :schedules)
    end
  end

  describe "as a customer service representative" do
    subject { Ability.new(csr) }

    it "can admin clients" do
      subject.should be_able_to(:access, "admin/clients")
    end

    it "can access customer service representatives" do
      subject.should be_able_to(:access, "customer_service_representatives")
    end
  end

  describe "as a manager director" do
    subject { Ability.new(manager_director) }

    it "can admin psychic_applications" do
      subject.should be_able_to(:access, "admin/psychic_applications")
    end

    it "can admin psychics" do
      subject.should be_able_to(:access, "admin/psychics")
    end
  end

  describe "as an accountant" do
    subject { Ability.new(accountant) }

    it "can admin invoices" do
      subject.should be_able_to(:access, "admin/invoices")
    end

    it "can admin payments" do
      subject.should be_able_to(:access, "admin/payments")
    end
  end
end
