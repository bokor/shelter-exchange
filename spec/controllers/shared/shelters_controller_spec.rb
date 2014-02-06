require "spec_helper"

describe Shared::SheltersController do
  login_user

  describe "GET auto_complete" do

    before do
      @shelter = Shelter.gen :name => "1 Test Shelter"
    end

    it "responds successfully" do
      get :auto_complete, :q => "test", :format => :json
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @shelters" do
      get :auto_complete, :q => "test", :format => :json
      expect(assigns(:shelters)).to match_array([@shelter])
    end

    it "renders json" do
      get :auto_complete, :q => "test", :format => :json
      expect(MultiJson.load(response.body)).to match_array([
        { "id" => @shelter.id, "name" => "1 Test Shelter", "lat" => "37.769929", "lng" => "-122.446682" }
      ])
    end
  end
end

