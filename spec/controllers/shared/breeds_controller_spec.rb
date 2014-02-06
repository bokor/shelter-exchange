require "spec_helper"

describe Shared::BreedsController do
  login_user

  describe "GET auto_complete" do

    before do
      @animal_type = AnimalType.gen
      @breed1 = Breed.gen :name => "1 Test Breed", :animal_type => @animal_type
      @breed2 = Breed.gen :name => "2 Test Breed", :animal_type => @animal_type
    end

    it "responds successfully" do
      get :auto_complete, :animal_type_id => @animal_type.id, :q => "test", :format => :json
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @breeds" do
      get :auto_complete, :animal_type_id => @animal_type.id, :q => "test", :format => :json
      expect(assigns(:breeds)).to match_array([@breed1, @breed2])
    end

    it "renders json" do
      get :auto_complete, :animal_type_id => @animal_type.id, :q => "test", :format => :json
      expect(MultiJson.load(response.body)).to match_array([
        { "id" => @breed1.id, "name" => "1 Test Breed" },
        { "id" => @breed2.id, "name" => "2 Test Breed" }
      ])
    end

    context "without an animal type" do
      it "returns without results" do
        get :auto_complete, :q => "test", :format => :json
        expect(MultiJson.load(response.body)).to eq([])
      end
    end
  end
end

