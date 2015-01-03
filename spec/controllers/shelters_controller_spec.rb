require "rails_helper"

describe SheltersController do
  login_user

  describe "GET index" do

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @shelter" do
      get :index
      expect(assigns(:shelter)).to eq(current_shelter)
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET edit" do

    it "responds successfully" do
      get :edit
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @shelter from current_shelter" do
      get :edit
      expect(assigns(:shelter)).to eq(current_shelter)
    end

    it "renders the :edit view" do
      get :edit
      expect(response).to render_template(:edit)
    end

    context "with failed authorization" do
      it "renders the errors/unauthorized template" do
        allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)

        get :edit
        expect(response).to render_template("errors/unauthorized")
      end
    end
  end

  describe "PUT update" do
    before do
      @update_attrs = { :name => "Test Shelter Name" }
    end

    it "responds successfully" do
      put :update, :shelter => @update_attrs, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates Shelter" do
      put :update, :shelter => @update_attrs
      expect(current_shelter.reload.name).to eq("Test Shelter Name")
    end

    it "assigns a newly updated shelter as @shelter" do
      put :update, :shelter => @update_attrs
      expect(assigns(:shelter)).to be_a(Shelter)
      expect(assigns(:shelter)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :shelter => @update_attrs
      expect(flash[:notice]).to eq("Test Shelter Name has been updated.")
    end

    it "redirects to the :shelters_path" do
      put :update, :shelter => @update_attrs
      expect(response).to redirect_to(shelters_path)
    end

    context "with js format" do
      it "renders the :update view" do
        put :update, :shelter => @update_attrs, :format => :js
        expect(response).to render_template(:update)
      end
    end

    context "with a update_attributes error" do
      it "does not set the flash message" do
        allow_any_instance_of(Shelter).to receive(:update_attributes).and_return(false)

        put :update, :shelter => @update_attrs
        expect(flash[:notice]).to be_nil
      end
    end
  end
end

