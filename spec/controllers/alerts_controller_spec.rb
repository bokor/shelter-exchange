require "spec_helper"

describe AlertsController do
  login_user

  describe "GET index" do

    before do
      @animal = Animal.gen :shelter => current_shelter
      @animal_alert = Alert.gen :alertable => @animal, :shelter => current_shelter
      @shelter_alert = Alert.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @animal_alerts" do
      another_alert = Alert.gen :alertable => @animal, :shelter => current_shelter

      get :index
      expect(assigns(:animal_alerts)).to eq([@animal_alert, another_alert])
    end

    it "assigns @shelter_alerts" do
      another_alert = Alert.gen :shelter => current_shelter

      get :index
      expect(assigns(:shelter_alerts)).to eq([@shelter_alert, another_alert])
    end

    it "assigns @alert_validate" do
      get :index
      expect(assigns(:alert_validate)).to be_true
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end

    context "without alerts" do
      it "redirects to the :new_alert_path" do
        @animal_alert.destroy
        @shelter_alert.destroy

        get :index
        expect(response).to redirect_to(new_alert_path)
      end
    end
  end

  describe "GET edit" do

    before do
      @alert = Alert.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :edit, :id => @alert.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @alert from id" do
      get :edit, :id => @alert.id, :format => :js
      expect(assigns(:alert)).to eq(@alert)
    end

    it "renders the :edit view" do
      get :edit, :id => @alert.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "GET new" do

    before do
      @accommodation = Accommodation.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :new
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns a new alert as @alert" do
      get :new
      expect(assigns(:alert)).to be_a_new(Alert)
    end

    it "renders the :new view" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do

    before do
      alert = Alert.build :title => "Alert test title", :shelter => current_shelter
      @attributes = alert.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :alert => @attributes, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Alert" do
      expect {
        post :create, :alert => @attributes
      }.to change(Alert, :count).by(1)
    end

    it "creates a new polymorphic Alert" do
      animal = Animal.gen :shelter => current_shelter
      alert = Alert.build \
        :title => "Alert test title",
        :alertable => animal,
        :shelter => current_shelter
      @attributes = alert.attributes.symbolize_keys.except(:created_at, :updated_at, :id)

      expect {
        post :create, :alert => @attributes
      }.to change(Alert, :count).by(1)
    end

    it "assigns a newly created alert as @alert" do
      post :create, :alert => @attributes
      expect(assigns(:alert)).to be_a(Alert)
      expect(assigns(:alert)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :alert => @attributes
      expect(flash[:notice]).to eq("Alert test title has been created.")
    end

    it "redirects to the :alerts_path" do
      post :create, :alert => @attributes
      expect(response).to redirect_to(alerts_path)
    end

    context "with a save error" do
      it "renders the :new view" do
        Alert.any_instance.stub(:save).and_return(false)

        post :create, :alert => @attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT update" do

    before do
      @alert = Alert.gen :title => "Alert Title", :shelter => current_shelter
      @update_attrs = { :title => "Update Alert Title" }
    end

    it "responds successfully" do
      put :update, :id => @alert, :alert => @update_attrs, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates a Alert" do
      expect {
        put :update, :id => @alert, :alert => @update_attrs, :format => :js
        @alert.reload
      }.to change(@alert, :title).to("Update Alert Title")
    end

    it "assigns a newly updated alert as @alert" do
      put :update, :id => @alert, :alert => @update_attrs, :format => :js
      expect(assigns(:alert)).to be_a(Alert)
      expect(assigns(:alert)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @alert, :alert => @update_attrs, :format => :js
      expect(flash[:notice]).to eq("Update Alert Title has been updated.")
    end

    it "renders the :edit view" do
      put :update, :id => @alert, :alert => @update_attrs, :format => :js
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "renders the :edit view" do
        Alert.any_instance.stub(:save).and_return(false)

        put :update, :id => @alert, :alert => @update_attrs, :format => :js
        expect(response).to render_template(:update)
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @alert = Alert.gen :title => "Title 1", :shelter => current_shelter
    end

    it "responds successfully" do
      delete :destroy, :id => @alert.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Alert" do
      expect {
        delete :destroy, :id => @alert.id, :format => :js
      }.to change(Alert, :count).by(-1)
    end

    it "sets the flash message" do
      delete :destroy, :id => @alert.id, :format => :js
      expect(flash[:notice]).to eq("Title 1 has been deleted.")
    end

    it "returns deleted @alert" do
      delete :destroy, :id => @alert.id, :format => :js
      expect(assigns(:alert)).to eq(@alert)
    end

    it "renders the :delete view" do
      delete :destroy, :id => @alert.id, :format => :js
      expect(response).to render_template(:destroy)
    end

    context "with a destroy error" do
      it "does not set a flash message" do
        Alert.any_instance.stub(:destroy).and_return(false)

        delete :destroy, :id => @alert.id, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "POST stop" do

    before do
      @alert = Alert.gen :shelter => current_shelter
    end

    it "responds successfully" do
      post :stop, :id => @alert.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "stops an alert" do
      expect(@alert.stopped).to be_false

      expect {
        post :stop, :id => @alert.id
      }.to change(Alert, :count).by(0)

      expect(@alert.reload.stopped).to be_true
    end

    it "sets the flash message" do
      post :stop, :id => @alert.id
      expect(flash[:notice]).to eq("Alert has been stopped.")
    end

    context "with a update error" do
      it "does not set a flash message" do
        Alert.any_instance.stub(:update_attributes).and_return(false)

        post :stop, :id => @alert.id
        expect(flash[:notice]).to be_nil
      end
    end
  end
end

