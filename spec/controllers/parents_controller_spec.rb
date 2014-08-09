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
      @parent1 = Parent.gen :first_name => "Brian", :last_name => "Bokor", :state => "CA"
      @parent2 = Parent.gen :first_name => "Claire", :last_name => "Bokor", :state => "NC"
      @parent3 = Parent.gen :first_name => "Jimmy", :last_name => " John", :state => "CA"
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
        expect(assigns(:parents)).to eq([@parent1, @parent2, @parent3])
      end
    end

    context "with pagination" do
      it "paginates :search results" do
        parent = Parent.gen :first_name => "paginated", :last_name => "parent"
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [parent] }

        get :search, :q => "paginated", :page => 1, :format => :js
        expect(assigns(:parents)).to eq([parent])
      end
    end
  end
end

