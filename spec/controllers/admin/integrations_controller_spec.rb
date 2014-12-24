require "rails_helper"

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

    it "assigns @access_token_count" do
      Shelter.gen :access_token => "123"
      Shelter.gen :access_token => "abc"
      Shelter.gen :access_token => nil

      get :index
      expect(assigns(:access_token_count)).to eq(2)
    end

    it "assigns @api_access" do
      dog_shelter = Shelter.gen :name => "Save Doggies", :access_token => "123abc"
      cat_shelter = Shelter.gen :name => "Save Kitties", :access_token => nil
      Integration.gen :petfinder, :shelter => dog_shelter
      Integration.gen :adopt_a_pet, :shelter => dog_shelter
      Integration.gen :petfinder, :shelter => cat_shelter

      get :index

      expect(assigns(:api_access)[dog_shelter]).to match_array([:adopt_a_pet, :petfinder, :access_token])
      expect(assigns(:api_access)[cat_shelter]).to match_array([:petfinder])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end

