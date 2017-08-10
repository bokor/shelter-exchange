require "rails_helper"

describe CommunitiesController do
  login_user

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
      @animal = Animal.gen
    end

    it "responds successfully" do
      get :show, :id => @animal.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @animal" do
      get :show, :id => @animal.id
      expect(assigns(:animal)).to eq(@animal)
    end

    it "assigns @shelter" do
      get :show, :id => @animal.id
      expect(assigns(:shelter)).to eq(@animal.shelter)
    end

    it "assigns @photos" do
      photo = Photo.gen :attachable => @animal
      get :show, :id => @animal.id
      expect(assigns(:photos)).to eq([photo])
    end

    it "assigns @gallery_photos" do
      Photo.gen :attachable => @animal
      get :show, :id => @animal.id
      presenter = PhotoPresenter.as_gallery_collection(assigns(:photos))
      expect(assigns(:gallery_photos)).to eq(presenter)
    end

    it "assigns @notes" do
      note = Note.gen :notable => @animal
      Note.gen :notable => @animal, :hidden => true

      get :show, :id => @animal.id
      expect(assigns(:notes)).to eq([note])
    end

    it "renders the :show view" do
      get :show, :id => @animal.id
      expect(response).to render_template(:show)
    end

    context "with a record not found error" do
      it "raises error" do
        bypass_rescue

        shelter = @animal.shelter
        shelter.update_attribute(:status, "suspended")

        expect {
          get :show, :id => @animal.id
        }.to raise_error(Errors::ShelterInactive)
      end

      it "sets the flash message" do
        get :show, :id => "123abc"
        expect(flash[:error]).to eq("You have requested an animal that is no longer listed!")
      end

      it "redirects to the :communities_path" do
        get :show, :id => "123abc"
        expect(response).to redirect_to(communities_path)
      end
    end
  end

  describe "GET filter_notes" do

    before do
      @animal = Animal.gen
      @general_note = Note.gen :category => "general", :notable => @animal
      @medical_note = Note.gen :category => "medical", :notable => @animal
    end

    it "responds successfully" do
      get :filter_notes, :animal_id => @animal.id, :filter => "", :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :filter_notes view" do
      get :filter_notes, :animal_id => @animal.id, :filter => "", :format => :js
      expect(response).to render_template(:filter_notes)
    end

    it "assigns @animal" do
      get :filter_notes, :animal_id => @animal.id, :filter => "", :format => :js
      expect(assigns(:animal)).to eq(@animal)
    end

    it "assigns @notes" do
      get :filter_notes, :animal_id => @animal.id, :filter => "general", :format => :js
      expect(assigns(:notes)).to eq([@general_note])
    end

    context "with no parameters" do
      it "assigns @notes" do
        get :filter_notes, :animal_id => @animal.id, :filter => "", :format => :js
        expect(assigns(:notes)).to match_array([@general_note, @medical_note])
      end
    end
  end

  describe "GET find_animals_in_bounds" do

    before do
      Geocoder::Lookup::Test.add_stub("street, street_2, city, state, zip_code", [
        { "latitude" => 37.27, "longitude" => -122.22 }
      ])

      current_shelter.update_attributes({ :lat => "37.27", :lng => "-122.22" })
      shelter1 = Shelter.gen :street => "street", :street_2 => "street_2", :city => "city", :state => "state", :zip_code => "zip_code"
      shelter2 = Shelter.gen :street => "street", :street_2 => "street_2", :city => "city", :state => "state", :zip_code => "zip_code"

      @animal1 = Animal.gen :shelter => shelter1, :animal_status_id => 1
      @animal2 = Animal.gen :shelter => shelter2, :animal_status_id => 1
      @animal3 = Animal.gen :shelter => current_shelter, :animal_status_id => 1

      @filters = {
        :map_center => "37.27,-122.22",
        :distance => "5",
        :sw => "37.25,-122.25",
        :ne => "37.30,-122.20"
      }
    end

    it "responds successfully" do
      get :find_animals_in_bounds, :filters => @filters, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :find_animals_in_bounds view" do
      get :find_animals_in_bounds, :filters => @filters, :format => :js
      expect(response).to render_template(:find_animals_in_bounds)
    end

    it "assigns @animals" do
      get :find_animals_in_bounds, :filters => @filters, :format => :js
      expect(assigns(:animals)).to match_array([@animal1, @animal2])
    end

    context "with pagination" do
      it "paginates :find_animals_in_bounds results" do
        allow(WillPaginate::Collection).to receive(:create).with(1, 10) { [@animal1] }

        get :find_animals_in_bounds, :page => 1, :filters => @filters, :format => :js
        expect(assigns(:animals)).to eq([@animal1])
      end
    end
  end

  describe "GET find_animals_for_shelter" do

    before do
      Geocoder::Lookup::Test.add_stub("street, street_2, city, state, zip_code", [
        { "latitude" => 37.27, "longitude" => -122.22 }
      ])

      @shelter = Shelter.gen :street => "street", :street_2 => "street_2", :city => "city", :state => "state", :zip_code => "zip_code"
      @animal = Animal.gen :shelter => @shelter, :animal_status_id => 1
      @capacity = Capacity.gen :shelter => @shelter

      @filters = {
        :map_center => "37.27,-122.22",
        :distance => "5",
        :sw => "37.25,-122.25",
        :ne => "37.30,-122.20",
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
      expect(assigns(:animals)).to eq([@animal])
    end

    it "assigns @capacities" do
      get :find_animals_for_shelter, :filters => @filters, :format => :js
      expect(assigns(:capacities)).to eq([@capacity])
    end

    context "with no active shelter" do
      it "does not assign @animals" do
        @shelter.update_attribute(:status, "suspended")
        get :find_animals_for_shelter, :filters => @filters, :format => :js
        expect(assigns(:animals)).to be_nil
      end

      it "does not assign @capacities" do
        @shelter.update_attribute(:status, "suspended")
        get :find_animals_for_shelter, :filters => @filters, :format => :js
        expect(assigns(:capacities)).to be_nil
      end
    end

    context "with pagination" do
      it "paginates :find_animals_for_shelter results" do
        allow(WillPaginate::Collection).to receive(:create).with(1, 10) { [@animal] }

        get :find_animals_for_shelter, :page => 1, :filters => @filters, :format => :js
        expect(assigns(:animals)).to eq([@animal])
      end
    end
  end
end

