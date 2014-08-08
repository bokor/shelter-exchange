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

