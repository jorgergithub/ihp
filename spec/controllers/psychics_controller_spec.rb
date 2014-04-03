require "spec_helper"

describe PsychicsController do
  describe "GET search" do
    before {
      get :search, params
    }

    context "with no search" do
      let(:params) { {} }
      let!(:psychic1) { create(:psychic) }
      let!(:psychic2) { create(:psychic) }

      it "renders 200" do
        expect(response.status).to eql(200)
      end

      it "includes all psychics" do
        expect(assigns(:psychics)).to include(psychic1)
        expect(assigns(:psychics)).to include(psychic2)
      end
    end

    context "searching by speciality" do
      let(:params) { {speciality: "love_and_relationships"} }
      let!(:psychic1) { create(:psychic, specialties_love_and_relationships: true) }
      let!(:psychic2) { create(:psychic, specialties_love_and_relationships: false) }

      it "renders 200" do
        expect(response.status).to eql(200)
      end

      it "includes the psychic that has the specialy" do
        expect(assigns(:psychics)).to include(psychic1)
      end

      it "excludes the psychic that doesn't have the specialy" do
        expect(assigns(:psychics)).to_not include(psychic2)
      end
    end

    context "searching by tool" do
      let(:params) { {tool: "numerology"} }
      let!(:psychic1) { create(:psychic, tools_numerology: true) }
      let!(:psychic2) { create(:psychic, tools_numerology: false) }

      it "renders 200" do
        expect(response.status).to eql(200)
      end

      it "includes the psychic that has the tool" do
        expect(assigns(:psychics)).to include(psychic1)
      end

      it "excludes the psychic that doesn't have the tool" do
        expect(assigns(:psychics)).to_not include(psychic2)
      end
    end

    context "searching by available" do
      let(:params) { {status: "available"} }
      let!(:psychic1) { create(:psychic) }
      let!(:psychic2) { create(:psychic) }

      before {
        psychic1.available!
      }

      it "renders 200" do
        expect(response.status).to eql(200)
      end

      it "includes the available psychic" do
        expect(assigns(:psychics)).to include(psychic1)
      end

      it "excludes the unavailable psychic" do
        expect(assigns(:psychics)).to_not include(psychic2)
      end
    end

    context "searching by price range" do
      let(:params) { {price_min: 5, price_max: 10} }
      let!(:psychic1) { create(:psychic, price: 5) }
      let!(:psychic2) { create(:psychic, price: 10) }
      let!(:psychic3) { create(:psychic, price: 11) }
      let!(:psychic4) { create(:psychic, price: 4) }

      it "renders 200" do
        expect(response.status).to eql(200)
      end

      it "includes the psychics within the range" do
        expect(assigns(:psychics)).to include(psychic1)
        expect(assigns(:psychics)).to include(psychic2)
      end

      it "excludes the psychics outside the range" do
        expect(assigns(:psychics)).to_not include(psychic3)
        expect(assigns(:psychics)).to_not include(psychic4)
      end
    end

    context "searching for featured only" do
      let(:params) { {featured: "true"} }
      let!(:psychic1) { create(:psychic, featured: true) }
      let!(:psychic2) { create(:psychic, featured: false) }

      it "renders 200" do
        expect(response.status).to eql(200)
      end

      it "includes the featured psychic" do
        expect(assigns(:psychics)).to include(psychic1)
      end

      it "excludes the psychic not featured" do
        expect(assigns(:psychics)).to_not include(psychic2)
      end
    end

    context "searching by text" do
      let(:params) { {text: "Alex"} }
      let!(:psychic1) { create(:psychic, pseudonym: "Alex") }
      let!(:psychic2) { create(:psychic, pseudonym: "Pedro") }

      before {
        psychic1.user.update_attributes first_name: "Pedro", last_name: "Richards"
        psychic2.user.update_attributes first_name: "Alex", last_name: "Alcantara"
      }

      it "renders 200" do
        expect(response.status).to eql(200)
      end

      it "includes the featured psychic" do
        expect(assigns(:psychics)).to include(psychic1)
      end

      it "excludes the psychic not featured" do
        expect(assigns(:psychics)).to_not include(psychic2)
      end
    end
  end
end
