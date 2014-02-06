require "spec_helper"

describe SettingsController do
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

    context "with tab as change_owner" do
      it "assigns @users" do
        another_user = User.gen :account => current_account
        get :index, :tab => "change_owner"
        expect(assigns(:users)).to match_array([current_user, another_user])
      end

      it "assigns @owner" do
        get :index, :tab => "change_owner"
        expect(assigns(:owner)).to eq(current_user)
      end
    end

    context "with tab as auto_upload" do
      it "assigns @adopt_a_pet" do
        Integration.gen \
          :type => "Integration::AdoptAPet",
          :shelter => current_shelter

        get :index, :tab => "auto_upload"
        expect(assigns(:adopt_a_pet)).to eq(Integration::AdoptAPet.last)
      end

      it "assigns @petfinder" do
        Integration.gen \
          :type => "Integration::Petfinder",
          :shelter => current_shelter

        get :index, :tab => "auto_upload"
        expect(assigns(:petfinder)).to eq(Integration::Petfinder.last)
      end
    end

    context "with failed authorization" do
      it "renders the errors/unauthorized template" do
        allow(controller).to receive(:authorize!).
          with(:view_settings, User).
          and_raise(CanCan::AccessDenied)

        get :index
        expect(response).to render_template("errors/unauthorized")
      end
    end

  end
end

