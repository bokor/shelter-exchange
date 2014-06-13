require "spec_helper"

describe Admin::IntegrationsController do
  login_owner

  before do
    allow(Net::FTP).to receive(:open).and_return(true)
  end

  describe "GET index" do

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @petfinder_count" do
      Integration.gen :petfinder
      Integration.gen :petfinder

      get :index
      expect(assigns(:petfinder_count)).to eq(2)
    end

    it "assigns @adopt_a_pet_count" do
      Integration.gen :adopt_a_pet
      Integration.gen :adopt_a_pet

      get :index
      expect(assigns(:adopt_a_pet_count)).to eq(2)
    end

    it "assigns @integrations_hash" do
      dog_shelter = Shelter.gen :name => "Save Doggies"
      cat_shelter = Shelter.gen :name => "Save Kitties"
      Integration.gen :petfinder, :shelter => dog_shelter
      Integration.gen :adopt_a_pet, :shelter => dog_shelter
      Integration.gen :petfinder, :shelter => cat_shelter

      get :index

      expect(assigns(:integrations_hash)[dog_shelter]).to match_array([:adopt_a_pet, :petfinder])
      expect(assigns(:integrations_hash)[cat_shelter]).to match_array([:petfinder])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end

