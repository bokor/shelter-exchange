require "rails_helper"

describe Admin::DashboardController do
  login_owner

  describe "GET index" do

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @counts_by_status" do
      available_for_adoption = AnimalStatus.gen :name => "Available for adoption"
      adopted = AnimalStatus.gen :name => "Adopted"
      Animal.gen :animal_status => available_for_adoption
      Animal.gen :animal_status => available_for_adoption
      Animal.gen :animal_status => adopted

      get :index
      expect(assigns(:counts_by_status)).to eq({
        "Adopted" => 1,
        "Available for adoption" => 2
      })
    end

    it "assigns @counts_by_transfer_with_app" do
      Transfer.gen :status => "completed"
      Transfer.gen :status => "completed"

      get :index
      expect(assigns(:counts_by_transfer_with_app)).to eq(2)
    end

    it "assigns @counts_by_transfer_without_app" do
      Animal.gen(:animal_status_id => AnimalStatus::STATUSES[:transferred])

      get :index
      expect(assigns(:counts_by_transfer_without_app)).to eq(1)
    end

    it "assigns @active_no_kill_shelters_count" do
      Shelter.gen :is_kill_shelter => false, :status => "active"
      Shelter.gen :is_kill_shelter => false, :status => "active"

      get :index
      expect(assigns(:active_no_kill_shelters_count)).to eq(2)
    end

    it "assigns @suspended_kill_shelters_count" do
      Shelter.gen :is_kill_shelter => true, :status => "suspended"
      Shelter.gen :is_kill_shelter => true, :status => "suspended"

      get :index
      expect(assigns(:suspended_kill_shelters_count)).to eq(2)
    end

    it "assigns @suspended_no_kill_shelters_count" do
      Shelter.gen :is_kill_shelter => false, :status => "suspended"
      Shelter.gen :is_kill_shelter => false, :status => "suspended"

      get :index
      expect(assigns(:suspended_no_kill_shelters_count)).to eq(2)
    end

    it "assigns @cancelled_kill_shelters_count" do
      Shelter.gen :is_kill_shelter => true, :status => "cancelled"
      Shelter.gen :is_kill_shelter => true, :status => "cancelled"

      get :index
      expect(assigns(:cancelled_kill_shelters_count)).to eq(2)
    end

    it "assigns @cancelled_no_kill_shelters_count" do
      Shelter.gen :is_kill_shelter => false, :status => "cancelled"
      Shelter.gen :is_kill_shelter => false, :status => "cancelled"

      get :index
      expect(assigns(:cancelled_no_kill_shelters_count)).to eq(2)
    end

    it "assigns @total_active_shelters_count" do
      Shelter.gen :is_kill_shelter => false, :status => "active"
      Shelter.gen :is_kill_shelter => true, :status => "active"

      get :index
      expect(assigns(:total_active_shelters_count)).to eq(2)
    end

    it "assigns @total_suspended_shelters_count" do
      Shelter.gen :is_kill_shelter => false, :status => "suspended"
      Shelter.gen :is_kill_shelter => true, :status => "suspended"

      get :index
      expect(assigns(:total_suspended_shelters_count)).to eq(2)
    end

    it "assigns @total_cancelled_shelters_count" do
      Shelter.gen :is_kill_shelter => false, :status => "cancelled"
      Shelter.gen :is_kill_shelter => true, :status => "cancelled"

      get :index
      expect(assigns(:total_cancelled_shelters_count)).to eq(2)
    end

    it "assigns @latest_shelters" do
      shelter = Shelter.gen
      allow(Shelter).to receive(:latest).with(10).and_return([shelter])

      get :index
      expect(assigns(:latest_shelters)).to match_array([shelter])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
