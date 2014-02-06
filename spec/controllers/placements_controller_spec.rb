require "spec_helper"

describe PlacementsController do
  login_user

  describe "POST create" do

    before do
      placement = Placement.build :status => "foster_care", :shelter => current_shelter
      @attributes = placement.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :placement => @attributes, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Placement" do
      expect {
        post :create, :placement => @attributes, :format => :js
      }.to change(Placement, :count).by(1)
    end

    it "assigns a newly created placement as @placement" do
      post :create, :placement => @attributes, :format => :js
      expect(assigns(:placement)).to be_a(Placement)
      expect(assigns(:placement)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :placement => @attributes, :format => :js
      expect(flash[:notice]).to eq("Foster care has been created.")
    end

    it "renders the :create view" do
      post :create, :placement => @attributes, :format => :js
      expect(response).to render_template(:create)
    end

    context "with a save error" do
      it "does not set a flash message" do
        allow_any_instance_of(Placement).to receive(:save).and_return(false)

        post :create, :placement => @attributes, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @placement = Placement.gen :status => "foster_care", :shelter => current_shelter
    end

    it "responds successfully" do
      delete :destroy, :id => @placement.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Placement" do
      expect {
        delete :destroy, :id => @placement.id, :format => :js
      }.to change(Placement, :count).by(-1)
    end

    it "returns deleted @placement" do
      delete :destroy, :id => @placement.id, :format => :js
      expect(assigns(:placement)).to eq(@placement)
    end

    it "renders the :delete view" do
      delete :destroy, :id => @placement.id, :format => :js
      expect(response).to render_template(:destroy)
    end
  end

  describe "GET find_comments" do

    before do
      @placement = Placement.gen :shelter => current_shelter
      @comment1 = Comment.gen :commentable => @placement
      @comment2 = Comment.gen :commentable => @placement
    end

    it "responds successfully" do
      get :find_comments, :id => @placement.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @comments" do
      get :find_comments, :id => @placement.id, :format => :js
      expect(assigns(:comments)).to match_array([@comment1, @comment2])
    end

    it "renders the :find_comments view" do
      get :find_comments, :id => @placement.id, :format => :js
      expect(response).to render_template(:find_comments)
    end
  end
end

