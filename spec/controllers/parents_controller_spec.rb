require "spec_helper"

describe ParentsController do
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
      @parent = Parent.gen
    end

    it "responds successfully" do
      get :show, :id => @parent.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @parent" do
      get :show, :id => @parent.id
      expect(assigns(:parent)).to eq(@parent)
    end

    it "assigns @adopted_placements" do
      adopted_placement = Placement.gen :parent => @parent, :status => "adopted"

      get :show, :id => @parent.id
      expect(assigns(:adopted_placements)).to match_array([adopted_placement])
    end

    it "assigns @foster_care_placements" do
      foster_care_placement = Placement.gen :parent => @parent, :status => "foster_care"

      get :show, :id => @parent.id
      expect(assigns(:foster_care_placements)).to match_array([foster_care_placement])
    end

    it "renders the :show view" do
      get :show, :id => @parent.id
      expect(response).to render_template(:show)
    end

    context "with a record not found error" do
      it "set a flash message" do
        get :show, :id => "123abc"
        expect(flash[:error]).to eq("You have requested an invalid parent!")
      end

      it "redirects to the :parents_path" do
        get :show, :id => "123abc"
        expect(response).to redirect_to(parents_path)
      end
    end
  end

  describe "GET edit" do

    before do
      @parent = Parent.gen
    end

    it "responds successfully" do
      get :edit, :id => @parent.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @parent" do
      get :edit, :id => @parent.id
      expect(assigns(:parent)).to eq(@parent)
    end

    it "renders the :edit view" do
      get :edit, :id => @parent.id
      expect(response).to render_template(:edit)
    end
  end

  describe "GET new" do

    it "responds successfully" do
      get :new
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns a new parent as @parent" do
      get :new
      expect(assigns(:parent)).to be_a_new(Parent)
    end

    it "renders the :new view" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do

    before do
      parent = Parent.build :name => "Joe Smith"
      @attributes = parent.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "creates a new Parent" do
      expect {
        post :create, :parent => @attributes
      }.to change(Parent, :count).by(1)
    end

    it "assigns a newly created parent as @parent" do
      post :create, :parent => @attributes
      expect(assigns(:parent)).to be_a(Parent)
      expect(assigns(:parent)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :parent => @attributes
      expect(flash[:notice]).to eq("Joe Smith has been created.")
    end

    it "redirects to the :parent_path" do
      post :create, :parent => @attributes
      expect(response).to redirect_to(parent_path(assigns(:parent)))
    end

    context "with a save error" do
      it "does not set a flash message" do
        allow_any_instance_of(Parent).to receive(:save).and_return(false)

        post :create, :parent => @attributes
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "PUT update" do

    before do
      @parent = Parent.gen :name => "Joe Smith"
      @update_attrs = { :name => "Jane Smith" }
    end

    it "updates a Parent" do
      expect {
        put :update, :id => @parent.id, :parent => @update_attrs
        @parent.reload
      }.to change(@parent, :name).to("Jane Smith")
    end

    it "assigns a newly updated parent as @accomodation" do
      put :update, :id => @parent.id, :parent => @update_attrs
      expect(assigns(:parent)).to be_a(Parent)
      expect(assigns(:parent)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @parent.id, :parent => @update_attrs
      expect(flash[:notice]).to eq("Jane Smith has been updated.")
    end

    it "redirects to the :parent_path" do
      put :update, :id => @parent.id, :parent => @update_attrs
      expect(response).to redirect_to(parent_path(assigns(:parent)))
    end

    context "with a update attributes error" do
      it "does not set a flash message" do
        allow_any_instance_of(Parent).to receive(:update_attributes).and_return(false)

        put :update, :id => @parent.id
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @parent = Parent.gen :name => "Joe Smith"
    end

    it "deletes an Parent" do
      expect {
        delete :destroy, :id => @parent.id
      }.to change(Parent, :count).by(-1)
    end

    it "sets the flash message" do
      delete :destroy, :id => @parent.id
      expect(flash[:notice]).to eq("Joe Smith has been deleted.")
    end

    it "returns deleted @parent" do
      delete :destroy, :id => @parent.id
      expect(assigns(:parent)).to eq(@parent)
    end

    it "redirects to the :parent_path" do
      delete :destroy, :id => @parent.id
      expect(response).to redirect_to(parents_path)
    end

    context "with a destroy error" do
      it "does not set a flash message" do
        allow_any_instance_of(Parent).to receive(:destroy).and_return(false)

        delete :destroy, :id => @parent.id
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "GET search" do

    before do
      @parent1 = Parent.gen :name => "Brian Bokor", :state => "CA"
      @parent2 = Parent.gen :name => "Claire Bokor", :state => "NC"
      @parent3 = Parent.gen :name => "Jimmy John", :state => "CA"
    end

    it "responds successfully" do
      get :search, :q => "", :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @parents" do
      get :search, :q => "bokor", :format => :js
      expect(assigns(:parents)).to eq([@parent1, @parent2])
    end

    context "with query parameters" do
      it "assigns @parents" do
        get :search, :q => "bokor", :parents => { :state => "CA" }, :format => :js
        expect(assigns(:parents)).to eq([@parent1])
      end
    end

    context "with no query parameters" do
      it "assigns @parents" do
        get :search, :q => " ", :format => :js
        expect(assigns(:parents)).to eq({})
      end
    end

    context "with pagination" do
      it "paginates :search results" do
        parent = Parent.gen :name => "paginated_parent"
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [parent] }

        get :search, :q => "paginated_parent", :page => 1, :format => :js
        expect(assigns(:parents)).to eq([parent])
      end
    end
  end
end

