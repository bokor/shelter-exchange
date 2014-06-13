require "spec_helper"

describe Admin::SheltersController do
  login_owner

  describe "GET index" do

    before do
      @kill_shelter = Shelter.gen :is_kill_shelter => true
      @no_kill_shelter = Shelter.gen :is_kill_shelter => false
    end

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @kill_shelters" do
      other_kill_shelter = Shelter.gen :is_kill_shelter => true

      get :index
      expect(assigns(:kill_shelters)).to match_array([@kill_shelter, other_kill_shelter])
    end

    it "assigns @no_kill_shelters" do
      other_no_kill_shelter = Shelter.gen :is_kill_shelter => false

      get :index
      expect(assigns(:no_kill_shelters)).to match_array([@no_kill_shelter, other_no_kill_shelter])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end

    context "with pagination" do
      it "paginates kill_shelters :index results" do
        kill_shelter = Shelter.gen :is_kill_shelter => true
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [kill_shelter] }

        get :index, :page => 1, :format => :js

        expect(assigns(:kill_shelters)).to eq([kill_shelter])
      end

      it "paginates no_kill_shelters :index results" do
        no_kill_shelter = Shelter.gen :is_kill_shelter => false
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [no_kill_shelter] }

        get :index, :page => 1, :format => :js

        expect(assigns(:no_kill_shelters)).to eq([no_kill_shelter])
      end
    end
  end

  describe "GET show" do

    before do
      account = Account.gen
      @shelter = account.shelters.first
    end

    it "responds successfully" do
      get :show, :id => @shelter.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @animal" do
      get :show, :id => @shelter.id
      expect(assigns(:shelter)).to eq(@shelter)
    end

    it "assigns @account" do
      get :show, :id => @shelter.id
      expect(assigns(:account)).to eq(@shelter.account)
    end

    it "assigns @capacities" do
      capacity1 = Capacity.gen :shelter => @shelter
      capacity2 = Capacity.gen :shelter => @shelter

      get :show, :id => @shelter.id
      expect(assigns(:capacities)).to match_array([capacity1, capacity2])
    end

    it "assigns @integrations" do
      allow(Net::FTP).to receive(:open).and_return(true)

      Integration.gen :petfinder, :shelter => @shelter

      get :show, :id => @shelter.id
      expect(assigns(:integrations)).to match_array([:petfinder])
    end

    it "assigns @users" do
      users = []
      @shelter.users.each {|user| users << user }
      other_user = User.gen :account => @shelter.account
      users << other_user

      get :show, :id => @shelter.id
      expect(assigns(:users)).to match_array(users)
    end

    it "assigns @counts_by_status" do
      available = AnimalStatus.gen :name => "available"
      adopted = AnimalStatus.gen :name => "adopted"

      Animal.gen :shelter => @shelter, :animal_status => available
      Animal.gen :shelter => @shelter, :animal_status => adopted

      get :show, :id => @shelter.id
      expect(assigns(:counts_by_status)).to eq({
        "adopted" => 1,
        "available" => 1
      })
    end

    it "renders the :show view" do
      get :show, :id => @shelter.id
      expect(response).to render_template(:show)
    end
  end

  describe "GET edit" do

    before do
      account = Account.gen
      @shelter = account.shelters.first
    end

    it "responds successfully" do
      get :edit, :id => @shelter.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @shelter" do
      get :edit, :id => @shelter.id, :format => :js
      expect(assigns(:shelter)).to eq(@shelter)
    end

    it "assigns @account" do
      get :edit, :id => @shelter.id, :format => :js
      expect(assigns(:account)).to eq(@shelter.account)
    end

    it "renders the :edit view" do
      get :edit, :id => @shelter.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT update" do

    before do
      account = Account.gen
      @shelter = account.shelters.first
      @shelter.update_column(:name, "Save the doggies")
      @update_attrs = { :status => "cancelled" }
    end

    it "responds successfully" do
      put :update, :id => @shelter.id, :shelter => @update_attrs, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates an Shelter" do
      expect {
        put :update, :id => @shelter.id, :shelter => @update_attrs, :format => :js
        @shelter.reload
      }.to change(@shelter, :status).to("cancelled")
    end

    it "assigns @shelter" do
      put :update, :id => @shelter.id, :shelter => @update_attrs, :format => :js
      expect(assigns(:shelter)).to be_a(Shelter)
      expect(assigns(:shelter)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @shelter.id, :shelter => @update_attrs, :format => :js
      expect(flash[:notice]).to eq("Save the doggies is now Cancelled.")
    end

    it "renders the :update view" do
      put :update, :id => @shelter.id, :shelter => @update_attrs, :format => :js
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "does not set a flash message" do
        allow_any_instance_of(Shelter).to receive(:update_attributes).and_return(false)

        put :update, :id => @shelter.id, :shelter => @update_attrs, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "GET live_search" do

    before do
      @kill_shelter1 = Shelter.gen :name => "search_test", :state => "CA", :is_kill_shelter => true
      @kill_shelter2 = Shelter.gen :name => "billy_joe", :state => "NC", :is_kill_shelter => true
      @no_kill_shelter1 = Shelter.gen :name => "test_search", :state => "CA", :is_kill_shelter => false
      @no_kill_shelter2 = Shelter.gen :name => "joe_billy", :state => "NC", :is_kill_shelter => false
    end

    it "responds successfully" do
      get :live_search, :q => "", :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @kill_shelters" do
      get :live_search, :q => "search", :format => :js
      expect(assigns(:kill_shelters)).to match_array([@kill_shelter1])
    end

    it "assigns @no_kill_shelters" do
      get :live_search, :q => "search", :format => :js
      expect(assigns(:no_kill_shelters)).to match_array([@no_kill_shelter1])
    end

    context "with shelter parameters" do
      it "assigns @kill_shelters" do
        get :live_search, :q => "billy", :shelters => { :state => "NC" }, :format => :js
        expect(assigns(:kill_shelters)).to match_array([@kill_shelter2])
      end

      it "assigns @no_kill_shelters" do
        get :live_search, :q => "billy", :shelters => { :state => "NC" }, :format => :js
        expect(assigns(:no_kill_shelters)).to match_array([@no_kill_shelter2])
      end
    end

    context "with pagination" do
      it "paginates kill_shelters :live_search results" do
        kill_shelter = Shelter.gen :is_kill_shelter => true
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [kill_shelter] }

        get :live_search, :q => "", :page => 1, :format => :js

        expect(assigns(:kill_shelters)).to eq([kill_shelter])
      end

      it "paginates no_kill_shelters :index results" do
        no_kill_shelter = Shelter.gen :is_kill_shelter => false
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [no_kill_shelter] }

        get :live_search, :q => "", :page => 1, :format => :js

        expect(assigns(:no_kill_shelters)).to eq([no_kill_shelter])
      end
    end
  end
end
