require "rails_helper"

describe Public::HelpAShelterController do

  describe "GET index" do

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET show" do

    before do
      @shelter = Shelter.gen
    end

    it "responds successfully" do
      get :show, :id => @shelter.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @shelter" do
      get :show, :id => @shelter.id
      expect(assigns(:shelter)).to eq(@shelter)
    end

    it "assigns @item_names" do
      Item.gen :name => "doggie item 1", :shelter => @shelter
      Item.gen :name => "doggie item 2", :shelter => @shelter
      Item.gen :name => "", :shelter => @shelter

      get :show, :id => @shelter.id
      expect(assigns(:item_names)).to match_array(["doggie item 1", "doggie item 2"])
    end

    it "renders the :show view" do
      get :show, :id => @shelter.id
      expect(response).to render_template(:show)
    end

    context "with a record not found error" do
      it "set a flash message" do
        get :show, :id => "123abc"
        expect(flash[:error]).to eq("You have requested a shelter that is no longer listed!")
      end

      it "renders the :index view" do
        get :show, :id => "123abc"
        expect(response).to render_template(:index)
      end

      it "responds with 404" do
        get :show, :id => "123abc"
        expect(response.status).to eq(404)
      end
    end
  end

  describe "GET search_by_shelter_or_rescue_group" do

    before do
      @shelter1 = Shelter.gen :name => "Doggie Lovers"
      @shelter2 = Shelter.gen :name => "Dog Lifesavers", :status => "suspended"
      @shelter3 = Shelter.gen :name => "Lifesavers for cats"
    end

    it "responds successfully" do
      get :search_by_shelter_or_rescue_group, :q => "", :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :search_by_shelter_or_rescue_group view" do
      get :search_by_shelter_or_rescue_group, :q => "", :format => :js
      expect(response).to render_template(:search_by_shelter_or_rescue_group)
    end

    it "assigns @shelters" do
      get :search_by_shelter_or_rescue_group, :q => "Dog", :format => :js
      expect(assigns(:shelters)).to match_array([@shelter1])
    end

    context "with pagination" do
      it "paginates :search_by_shelter_or_rescue_group results" do
        allow(WillPaginate::Collection).to receive(:create).with(1, 15) { [@shelter1] }

        get :search_by_shelter_or_rescue_group, :page => 1, :q => "Dog", :format => :js
        expect(assigns(:shelters)).to eq([@shelter1])
      end
    end
  end

  describe "GET find_shelters_in_bounds" do

    before do
      Geocoder::Lookup::Test.add_stub("street, street_2, city, state, zip_code", [
        { "latitude" => 37.27, "longitude" => -122.22 }
      ])

      @shelter1 = Shelter.gen :street => "street", :street_2 => "street_2", :city => "city", :state => "state", :zip_code => "zip_code"
      @shelter2 = Shelter.gen :street => "street", :street_2 => "street_2", :city => "city", :state => "state", :zip_code => "zip_code"
      @shelter3 = Shelter.gen

      @filters = {
        :map_center => "37.27,-122.22",
        :distance => "5",
        :sw => "37.25,-122.25",
        :ne => "37.30,-122.20"
      }
    end

    it "responds successfully" do
      get :find_shelters_in_bounds, :filters => @filters, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :find_shelters_in_bounds view" do
      get :find_shelters_in_bounds, :filters => @filters, :format => :js
      expect(response).to render_template(:find_shelters_in_bounds)
    end

    it "assigns @shelters" do
      get :find_shelters_in_bounds, :filters => @filters, :format => :js
      expect(assigns(:shelters)).to match_array([@shelter1, @shelter2])
    end

    context "with pagination" do
      it "paginates :find_shelters_in_bounds results" do
        allow(WillPaginate::Collection).to receive(:create).with(1, 15) { [@shelter1] }

        get :find_shelters_in_bounds, :page => 1, :filters => @filters, :format => :js
        expect(assigns(:shelters)).to eq([@shelter1])
      end
    end
  end

  describe "GET find_animals_for_shelter" do

    before do
      Geocoder::Lookup::Test.add_stub("street, street_2, city, state, zip_code", [
        { "latitude" => 37.27, "longitude" => -122.22 }
      ])

      @shelter = Shelter.gen :street => "street", :street_2 => "street_2", :city => "city", :state => "state", :zip_code => "zip_code"
      @animal1 = Animal.gen :shelter => @shelter, :animal_status_id => 1, :primary_breed => "Lab"
      @animal2 = Animal.gen :shelter => @shelter, :animal_status_id => 1
      @animal3 = Animal.gen :shelter => @shelter, :animal_status_id => 2

      @filters = {
        :shelter_id => @shelter.id
      }
    end

    it "responds successfully" do
      get :find_animals_for_shelter, :filters => @filters, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :find_animals_for_shelter view" do
      get :find_animals_for_shelter, :filters => @filters, :format => :js
      expect(response).to render_template(:find_animals_for_shelter)
    end

    it "assigns @animals" do
      get :find_animals_for_shelter, :filters => @filters, :format => :js
      expect(assigns(:animals)).to eq([@animal1, @animal2])
    end

    context "with filters" do
      it "assigns @animals" do
        @filters[:breed] = "Lab"
        get :find_animals_for_shelter, :filters => @filters, :format => :js
        expect(assigns(:animals)).to eq([@animal1])
      end
    end

    context "with pagination" do
      it "paginates :find_animals_for_shelter results" do
        allow(WillPaginate::Collection).to receive(:create).with(1, 15) { [@animal1] }

        get :find_animals_for_shelter, :page => 1, :filters => @filters, :format => :js
        expect(assigns(:animals)).to eq([@animal1])
      end
    end
  end
end

