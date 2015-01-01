require "rails_helper"

describe Public::SaveALifeController do

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
      photo1 = Photo.gen :attachable => @animal
      photo2 = Photo.gen :attachable => @animal

      get :show, :id => @animal.id
      expect(assigns(:photos)).to match_array([photo1, photo2])
    end

    it "assigns @gallery_photos" do
      Photo.gen :attachable => @animal
      Photo.gen :attachable => @animal

      get :show, :id => @animal.id
      expect(assigns(:gallery_photos)).to eq(PhotoPresenter.as_gallery_collection(assigns(:photos)))
    end

    it "renders the :show view" do
      get :show, :id => @animal.id
      expect(response).to render_template(:show)
    end

    context "with a record not found error" do
      it "set a flash message" do
        get :show, :id => "123abc"
        expect(flash[:error]).to eq("You have requested an animal that is no longer listed!")
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

    context "when shelter is inactive" do

      before do
        @animal.shelter.update_attribute(:status, "cancelled")
      end

      it "set a flash message" do
        get :show, :id => @animal.id
        expect(flash[:error]).to eq("You have requested an animal that is no longer listed!")
      end

      it "renders the :index view" do
        get :show, :id => @animal.id
        expect(response).to render_template(:index)
      end

      it "responds with 404" do
        get :show, :id => @animal.id
        expect(response.status).to eq(404)
      end
    end
  end

  describe "GET find_animals_in_bounds" do

    before do
      Geocoder::Lookup::Test.add_stub("street, street_2, city, state, zip_code", [
        { "latitude" => 37.27, "longitude" => -122.22 }
      ])

      shelter1 = Shelter.gen :street => "street", :street_2 => "street_2", :city => "city", :state => "state", :zip_code => "zip_code"
      shelter2 = Shelter.gen :street => "street", :street_2 => "street_2", :city => "city", :state => "state", :zip_code => "zip_code"
      shelter3 = Shelter.gen :status => "cancelled", :street => "street", :street_2 => "street_2", :city => "city", :state => "state", :zip_code => "zip_code"

      @animal1 = Animal.gen :shelter => shelter1, :animal_status_id => 1, :primary_breed => "Lab"
      @animal2 = Animal.gen :shelter => shelter2, :animal_status_id => 1
      @animal3 = Animal.gen :shelter => shelter3, :animal_status_id => 1

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

    context "with filter" do
      it "assigns @animals" do
        get :find_animals_in_bounds, :filters => @filters.merge(:breed => "Lab"), :format => :js
        expect(assigns(:animals)).to match_array([@animal1])
      end
    end

    context "with pagination" do
      it "paginates :find_animals_in_bounds results" do
        allow(WillPaginate::Collection).to receive(:create).with(1, 10) { [@animal1] }

        get :find_animals_in_bounds, :page => 1, :filters => @filters, :format => :js
        expect(assigns(:animals)).to eq([@animal1])
      end
    end
  end
end

