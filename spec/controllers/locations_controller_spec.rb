require "rails_helper"

describe LocationsController do
  login_user

  describe "GET edit" do

    before do
      @location = Location.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :edit, :id => @location.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @location from id" do
      get :edit, :id => @location.id, :format => :js
      expect(assigns(:location)).to eq(@location)
    end

    it "renders the :edit view" do
      get :edit, :id => @location.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "POST create" do

    before do
      location = Location.build :name => "kennel", :shelter => current_shelter
      @attributes = location.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :location => @attributes, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Location" do
      expect {
        post :create, :location => @attributes, :format => :js
      }.to change(Location, :count).by(1)
    end

    it "assigns a newly created location as @location" do
      post :create, :location => @attributes, :format => :js
      expect(assigns(:location)).to be_a(Location)
      expect(assigns(:location)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :location => @attributes, :format => :js
      expect(flash[:notice]).to eq("kennel has been created.")
    end

    it "renders the :create view" do
      post :create, :location => @attributes, :format => :js
      expect(response).to render_template(:create)
    end

    context "with a save error" do
      it "does not set a flash message" do
        allow_any_instance_of(Location).to receive(:save).and_return(false)

        post :create, :location => @attributes, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "PUT update" do

    before do
      @location = Location.gen :name => "red kennel", :shelter => current_shelter
      @update_attrs = { :name => "blue kennel" }
    end

    it "responds successfully" do
      put :update, :id => @location, :location => @update_attrs, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates a Location" do
      put :update, :id => @location, :location => @update_attrs, :format => :js
      expect(@location.reload.name).to eq("blue kennel")
    end

    it "assigns a newly updated location as @location" do
      put :update, :id => @location, :location => @update_attrs, :format => :js
      expect(assigns(:location)).to be_a(Location)
      expect(assigns(:location)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @location, :location => @update_attrs, :format => :js
      expect(flash[:notice]).to eq("blue kennel has been updated.")
    end

    it "renders the :update view" do
      put :update, :id => @location, :location => @update_attrs, :format => :js
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "does not set the flash message" do
        allow_any_instance_of(Location).to receive(:update_attributes).and_return(false)

        put :update, :id => @location, :location => @update_attrs, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @location = Location.gen :shelter => current_shelter
    end

    it "responds successfully" do
      delete :destroy, :id => @location.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Location" do
      expect {
        delete :destroy, :id => @location.id, :format => :js
      }.to change(Location, :count).by(-1)
    end

    it "returns deleted @location" do
      delete :destroy, :id => @location.id, :format => :js
      expect(assigns(:location)).to eq(@location)
    end

    it "renders the :delete view" do
      delete :destroy, :id => @location.id, :format => :js
      expect(response).to render_template(:destroy)
    end
  end

  describe "GET find_all" do

    before do
      @location1 = Location.gen :shelter => current_shelter
      @location2 = Location.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :find_all, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @locations" do
      get :find_all, :format => :js
      expect(assigns(:locations)).to match_array([@location1, @location2])
    end

    it "renders the :find_all view" do
      get :find_all, :format => :js
      expect(response).to render_template(:find_all)
    end
  end
end

