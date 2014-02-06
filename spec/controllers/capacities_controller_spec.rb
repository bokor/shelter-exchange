require "spec_helper"

describe CapacitiesController do
  login_user

  describe "GET index" do

    before do
      @capacity = Capacity.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @capacities" do
      another_capacity = Capacity.gen :shelter => current_shelter

      get :index
      expect(assigns(:capacities)).to eq([@capacity, another_capacity])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end

    context "without capacities" do
      it "redirects to the :new_capacity_path" do
        @capacity.destroy
        get :index
        expect(response).to redirect_to(new_capacity_path)
      end
    end
  end

  describe "GET new" do

    it "responds successfully" do
      get :new
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns a new capacity as @capacity" do
      get :new
      expect(assigns(:capacity)).to be_a_new(Capacity)
    end

    it "renders the :new view" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "GET edit" do

    before do
      @capacity = Capacity.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :edit, :id => @capacity.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @capacity from id" do
      get :edit, :id => @capacity.id, :format => :js
      expect(assigns(:capacity)).to eq(@capacity)
    end

    it "renders the :edit view" do
      get :edit, :id => @capacity.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "POST create" do

    before do
      capacity = Capacity.build :shelter => current_shelter
      @attributes = capacity.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :capacity => @attributes, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Note" do
      expect {
        post :create, :capacity => @attributes
      }.to change(Capacity, :count).by(1)
    end

    it "assigns a newly created capacity as @capacity" do
      post :create, :capacity => @attributes
      expect(assigns(:capacity)).to be_a(Capacity)
      expect(assigns(:capacity)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :capacity => @attributes
      expect(flash[:notice]).to eq("Shelter Capacity has been created.")
    end

    it "redirects to the :capacities_path" do
      post :create, :capacity => @attributes
      expect(response).to redirect_to(capacities_path)
    end

    context "with js format" do
      it "renders the :create view" do
        post :create, :capacity => @attributes, :format => :js
        expect(response).to render_template(:create)
      end
    end

    context "with a save error" do
      before do
        allow_any_instance_of(Capacity).to receive(:save).and_return(false)
      end

      it "does not set a flash message" do
        post :create, :capacity => @attributes
        expect(flash[:notice]).to be_nil
      end

      it "renders the :new view" do
        post :create, :capacity => @attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT update" do

    before do
      @capacity = Capacity.gen :max_capacity => 15, :shelter => current_shelter
      @update_attrs = { :max_capacity => 25 }
    end

    it "responds successfully" do
      put :update, :id => @capacity, :capacity => @update_attrs, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates a Capacity" do
      put :update, :id => @capacity, :capacity => @update_attrs, :format => :js
      expect(@capacity.reload.max_capacity).to eq(25)
    end

    it "assigns a newly updated capacity as @capacity" do
      put :update, :id => @capacity, :capacity => @update_attrs, :format => :js
      expect(assigns(:capacity)).to be_a(Capacity)
      expect(assigns(:capacity)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @capacity, :capacity => @update_attrs, :format => :js
      expect(flash[:notice]).to eq("Shelter Capacity has been updated.")
    end

    it "renders the :update view" do
      put :update, :id => @capacity, :capacity => @update_attrs, :format => :js
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "does not set the flash message" do
        allow_any_instance_of(Capacity).to receive(:update_attributes).and_return(false)

        put :update, :id => @capacity, :capacity => @update_attrs, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @capacity = Capacity.gen :shelter => current_shelter
    end

    it "responds successfully" do
      delete :destroy, :id => @capacity.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes a Capacity" do
      expect {
        delete :destroy, :id => @capacity.id, :format => :js
      }.to change(Capacity, :count).by(-1)
    end

    it "returns deleted @capacity" do
      delete :destroy, :id => @capacity.id, :format => :js
      expect(assigns(:capacity)).to eq(@capacity)
    end

    it "renders the :delete view" do
      delete :destroy, :id => @capacity.id, :format => :js
      expect(response).to render_template(:destroy)
    end

    it "sets the flash message" do
      delete :destroy, :id => @capacity.id, :format => :js
      expect(flash[:notice]).to eq("Shelter Capacity has been deleted.")
    end

    context "with a save error" do
      it "does not set the flash message" do
        allow_any_instance_of(Capacity).to receive(:destroy).and_return(false)

        delete :destroy, :id => @capacity.id, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end
end

