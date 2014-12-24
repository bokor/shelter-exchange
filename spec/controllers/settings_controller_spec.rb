require "rails_helper"

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

      before do
        allow(Net::FTP).to receive(:open).and_return(true)
      end

      it "assigns @adopt_a_pet" do
        integration = Integration.gen :adopt_a_pet, :shelter => current_shelter

        get :index, :tab => "auto_upload"
        expect(assigns(:adopt_a_pet)).to eq(integration)
      end

      it "assigns @petfinder" do
        integration = Integration.gen :petfinder, :shelter => current_shelter

        get :index, :tab => "auto_upload"
        expect(assigns(:petfinder)).to eq(integration)
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

