require "rails_helper"

describe Admin::AnnouncementsController do
  login_owner

  describe "GET index" do

    before do
      @announcement = Announcement.gen
    end

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @announcement" do
      another_announcement = Announcement.gen

      get :index
      expect(assigns(:announcements)).to eq([@announcement, another_announcement])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET edit" do

    before do
      @announcement = Announcement.gen
    end

    it "responds successfully" do
      get :edit, :id => @announcement.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @announcement from id" do
      get :edit, :id => @announcement.id, :format => :js
      expect(assigns(:announcement)).to eq(@announcement)
    end

    it "renders the :edit view" do
      get :edit, :id => @announcement.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "POST create" do

    before do
      announcement = Announcement.build \
        :title => "New Feature",
        :message => "you gonna like",
        :category => "general"
      @attributes = announcement.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :announcement => @attributes, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Announcement" do
      expect {
        post :create, :announcement => @attributes
      }.to change(Announcement, :count).by(1)
    end

    it "assigns a newly created Announcement as @announcement" do
      post :create, :announcement => @attributes
      expect(assigns(:announcement)).to be_a(Announcement)
      expect(assigns(:announcement)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :announcement => @attributes
      expect(flash[:notice]).to eq("New Feature has been created.")
    end

    it "renders the :create view" do
      post :create, :announcement => @attributes, :format => :js
      expect(response).to render_template(:create)
    end

    context "with a save error" do
      it "does not set a flash message" do
        allow_any_instance_of(Announcement).to receive(:save).and_return(false)

        post :create, :announcement => @attributes, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "PUT update" do

    before do
      @announcement = Announcement.gen \
        :title => "New Feature",
        :message => "you gonna like",
        :category => "general"
      @update_attrs = { :message => "feature is super cool!" }
    end

    it "responds successfully" do
      put :update, :id => @announcement.id, :announcement => @update_attrs, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates an Announcement" do
      expect {
        put :update, :id => @announcement.id, :announcement => @update_attrs, :format => :js
        @announcement.reload
      }.to change(@announcement, :message).to("feature is super cool!")
    end

    it "assigns @announcement" do
      put :update, :id => @announcement.id, :announcement => @update_attrs, :format => :js
      expect(assigns(:announcement)).to be_a(Announcement)
      expect(assigns(:announcement)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @announcement.id, :announcement => @update_attrs, :format => :js
      expect(flash[:notice]).to eq("New Feature has been updated.")
    end

    it "renders the :update view" do
      put :update, :id => @announcement.id, :announcement => @update_attrs, :format => :js
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "renders the :update view" do
        allow_any_instance_of(Announcement).to receive(:update_attributes).and_return(false)

        put :update, :id => @announcement.id, :announcement => @update_attrs, :format => :js
        expect(response).to render_template(:update)
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @announcement = Announcement.gen \
        :title => "New Feature",
        :message => "you gonna like",
        :category => "general"
    end

    it "responds successfully" do
      delete :destroy, :id => @announcement.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Announcement" do
      expect {
        delete :destroy, :id => @announcement.id, :format => :js
      }.to change(Announcement, :count).by(-1)
    end

    it "sets the flash message" do
      delete :destroy, :id => @announcement.id, :format => :js
      expect(flash[:notice]).to eq("New Feature has been deleted.")
    end

    it "returns deleted @announcement" do
      delete :destroy, :id => @announcement.id, :format => :js
      expect(assigns(:announcement)).to eq(@announcement)
    end

    it "renders the :delete view" do
      delete :destroy, :id => @announcement.id, :format => :js
      expect(response).to render_template(:destroy)
    end

    context "with a destroy error" do
      it "does not set a flash message" do
        allow_any_instance_of(Announcement).to receive(:destroy).and_return(false)

        delete :destroy, :id => @announcement.id, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end
end
