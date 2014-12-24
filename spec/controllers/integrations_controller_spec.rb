require "rails_helper"

describe IntegrationsController do
  login_user

  before do
    allow(Net::FTP).to receive(:open).and_return(true)
  end

  describe "POST create" do

    before do
      integration = Integration.build :adopt_a_pet, :shelter => current_shelter
      @attributes = integration.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :integration => @attributes, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Integration" do
      expect {
        post :create, :integration => @attributes, :format => :js
      }.to change(Integration, :count).by(1)
    end

    it "assigns a newly created integration as @integration" do
      post :create, :integration => @attributes, :format => :js
      expect(assigns(:integration)).to be_a(Integration)
      expect(assigns(:integration)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :integration => @attributes, :format => :js
      expect(flash[:notice]).to eq("Adopt a pet has been connected.")
    end

    it "renders the :create view" do
      post :create, :integration => @attributes, :format => :js
      expect(response).to render_template(:create)
    end

    context "with a save error" do
      it "does not set a flash message" do
        allow_any_instance_of(Integration).to receive(:save).and_return(false)

        post :create, :integration => @attributes, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @integration = Integration.gen :adopt_a_pet, :shelter => current_shelter
    end

    it "responds successfully" do
      delete :destroy, :id => @integration.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Integration" do
      expect {
        delete :destroy, :id => @integration.id, :format => :js
      }.to change(Integration, :count).by(-1)
    end

    it "returns new integration of type of old one as @integration" do
      delete :destroy, :id => @integration.id, :format => :js
      expect(assigns(:integration)).to be_a(Integration::AdoptAPet)
      expect(assigns(:integration)).to_not be_persisted
    end

    it "renders the :delete view" do
      delete :destroy, :id => @integration.id, :format => :js
      expect(response).to render_template(:destroy)
    end

    it "sets the flash message" do
      delete :destroy, :id => @integration.id, :format => :js
      expect(flash[:notice]).to eq("Adopt a pet has been revoked.")
    end

    context "with a save error" do
      it "does not set a flash message" do
        allow_any_instance_of(Integration).to receive(:destroy).and_return(false)

        delete :destroy, :id => @integration.id, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end
end

