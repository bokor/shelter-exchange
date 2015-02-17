require "rails_helper"

describe AccommodationsController do
  login_user

  describe "GET index" do

    before do
      @accommodation = Accommodation.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @accommodations" do
      another_accommodation = Accommodation.gen :shelter => current_shelter

      get :index
      expect(assigns(:accommodations)).to eq([@accommodation, another_accommodation])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end

    context "without accommodations" do
      it "redirects to the :new_accommodation_path" do
        @accommodation.destroy
        get :index
        expect(response).to redirect_to(new_accommodation_path)
      end
    end

    context "with search params" do

      it "renders the :index view" do
        get :index, :format => :js
        expect(response).to render_template(:index)
      end

      it "assigns @accommodations" do
        location = Location.gen
        @accommodation.update_attributes({:name => "Banana Apple", :animal_type_id => 1, :location_id => location.id})
        another_accommodation = Accommodation.gen(
          :name => "Apple Banana",
          :animal_type_id => 1,
          :location_id => location.id,
          :shelter => current_shelter
        )

        get :index, {
          :query => "Apple",
          :animal_type_id => 1,
          :location_id => location.id,
          :order_by => "accommodations.name ASC",
          :format => :js
        }
        expect(assigns(:accommodations)).to eq([another_accommodation, @accommodation])
      end
    end

    context "with pagination" do
      it "paginates :index results" do
        accommodation = Accommodation.gen :name => "paginated_search", :shelter => current_shelter
        allow(WillPaginate::Collection).to receive(:create).with(1, 50) { [accommodation] }

        get :index, :page => 1, :format => :js

        expect(assigns(:accommodations)).to eq([accommodation])
      end
    end
  end

  describe "GET edit" do

    before do
      @accommodation = Accommodation.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :edit, :id => @accommodation.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @accommodation from id" do
      get :edit, :id => @accommodation.id, :format => :js
      expect(assigns(:accommodation)).to eq(@accommodation)
    end

    it "renders the :edit view" do
      get :edit, :id => @accommodation.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "GET new" do

    it "responds successfully" do
      get :new
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns a new accommodation as @accommodation" do
      get :new
      expect(assigns(:accommodation)).to be_a_new(Accommodation)
    end

    it "renders the :new view" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do

    before do
      accommodation = Accommodation.build :name => "Controller Crate", :shelter => current_shelter
      @attributes = accommodation.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :accommodation => @attributes, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Accomodation" do
      expect {
        post :create, :accommodation => @attributes
      }.to change(Accommodation, :count).by(1)
    end

    it "assigns a newly created accommodation as @accomodation" do
      post :create, :accommodation => @attributes
      expect(assigns(:accommodation)).to be_a(Accommodation)
      expect(assigns(:accommodation)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :accommodation => @attributes
      expect(flash[:notice]).to eq("Controller Crate accommodation has been created.")
    end

    it "redirects to the :accommodations_path" do
      post :create, :accommodation => @attributes
      expect(response).to redirect_to(accommodations_path)
    end

    context "with a save error" do
      it "renders the :new view" do
        allow_any_instance_of(Accommodation).to receive(:save).and_return(false)

        post :create, :accommodation => @attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT update" do

    before do
      @accommodation = Accommodation.gen :name => "Crate 1", :shelter => current_shelter
      @update_attrs = { :name => "Update Crate" }
    end

    it "responds successfully" do
      put :update, :id => @accommodation.id, :accommodation => @update_attrs, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates an Accomodation" do
      expect {
        put :update, :id => @accommodation.id, :accommodation => @update_attrs, :format => :js
        @accommodation.reload
      }.to change(@accommodation, :name).to("Update Crate")
    end

    it "assigns @accomodation" do
      put :update, :id => @accommodation.id, :accommodation => @update_attrs, :format => :js
      expect(assigns(:accommodation)).to be_a(Accommodation)
      expect(assigns(:accommodation)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @accommodation.id, :accommodation => @update_attrs, :format => :js
      expect(flash[:notice]).to eq("Update Crate accommodation has been updated.")
    end

    it "renders the :update view" do
      put :update, :id => @accommodation.id, :accommodation => @update_attrs, :format => :js
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "renders the :update view" do
        allow_any_instance_of(Accommodation).to receive(:update_attributes).and_return(false)

        put :update, :id => @accommodation.id, :accommodation => @update_attrs, :format => :js
        expect(response).to render_template(:update)
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @accommodation = Accommodation.gen :name => "Crate 1", :shelter => current_shelter
    end

    it "responds successfully" do
      delete :destroy, :id => @accommodation.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Accomodation" do
      expect {
        delete :destroy, :id => @accommodation.id, :format => :js
      }.to change(Accommodation, :count).by(-1)
    end

    it "sets the flash message" do
      delete :destroy, :id => @accommodation.id, :format => :js
      expect(flash[:notice]).to eq("Crate 1 accommodation has been deleted.")
    end

    it "returns deleted @accommodation" do
      delete :destroy, :id => @accommodation.id, :format => :js
      expect(assigns(:accommodation)).to eq(@accommodation)
    end

    it "renders the :delete view" do
      delete :destroy, :id => @accommodation.id, :format => :js
      expect(response).to render_template(:destroy)
    end

    context "with a destroy error" do
      it "does not set a flash message" do
        allow_any_instance_of(Accommodation).to receive(:destroy).and_return(false)

        delete :destroy, :id => @accommodation.id, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end
end

