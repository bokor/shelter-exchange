require "rails_helper"

describe DashboardController do
  login_user

  describe "GET index" do

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @latest_activity" do
      task = Task.gen :shelter => current_shelter
      animal = Animal.gen :shelter => current_shelter

      get :index
      expect(assigns(:latest_activity)).to match_array([task, animal])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end

