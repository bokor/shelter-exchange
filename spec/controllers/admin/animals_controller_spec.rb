require "rails_helper"

describe Admin::AnimalsController do
  login_owner

  describe "GET index" do

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @latest_adopted" do
      allow(Animal).to receive(:latest).with(:adopted, 50).and_call_original
      # TODO: Remove euthanized stub when I figure out how to bypass call
      allow(Animal).to receive(:latest).with(:euthanized, 10).and_call_original

      animal1 = Animal.gen :animal_status_id => AnimalStatus::STATUSES[:adopted]
      animal2 = Animal.gen :animal_status_id => AnimalStatus::STATUSES[:adopted]

      get :index
      expect(assigns(:latest_adopted)).to match_array([animal1, animal2])
    end

    it "assigns @latest_euthanized" do
      # TODO: Remove adopted stub when I figure out how to bypass call
      allow(Animal).to receive(:latest).with(:adopted, 50).and_call_original
      allow(Animal).to receive(:latest).with(:euthanized, 10).and_call_original

      animal1 = Animal.gen :animal_status_id => AnimalStatus::STATUSES[:euthanized]
      animal2 = Animal.gen :animal_status_id => AnimalStatus::STATUSES[:euthanized]

      get :index
      expect(assigns(:latest_euthanized)).to match_array([animal1, animal2])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET live_search" do

    before do
      other_shelter = Shelter.gen :state => "NC"
      @animal1 = Animal.gen :name => "search_test", :animal_status_id => AnimalStatus::NON_ACTIVE[0]
      @animal2 = Animal.gen :name => "test_search", :shelter => other_shelter, :animal_status_id => AnimalStatus::NON_ACTIVE[0]
      @animal3 = Animal.gen :name => "billy", :animal_status_id => AnimalStatus::ACTIVE[0]
    end

    it "responds successfully" do
      get :live_search, :q => "", :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @animals" do
      get :live_search, :q => "search", :format => :js
      expect(assigns(:animals)).to match_array([@animal1, @animal2])
    end

    context "with shelter parameters" do
      it "assigns @animals" do
        get :live_search, :q => "", :shelters => { :state => "NC" }, :format => :js
        expect(assigns(:animals)).to eq([@animal2])
      end

      it "assigns @animals with empty params" do
        get :live_search, :q => "", :shelters => { :state => "" }, :format => :js
        expect(assigns(:animals)).to match_array([@animal1, @animal2, @animal3])
      end
    end
  end
end
