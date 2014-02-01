require "spec_helper"

describe TokenAuthenticationsController do
  login_user

  describe "POST create" do

    it "redirects to the :settings_path" do
      post :create
      expect(response).to redirect_to("/settings/web_access")
    end

    it "create new shelter access token" do
      allow(SecureRandom).to receive(:hex).and_return("xxx12345xxx")

      post :create
      expect(current_shelter.access_token).to eq("xxx12345xxx")
    end

    context "with failed authorization" do
      it "renders the errors/unauthorized template" do
        allow(controller).to receive(:authorize!).
          with(:generate_access_token, current_shelter).
          and_raise(CanCan::AccessDenied)

        post :create, :format => :html
        expect(response).to render_template("errors/unauthorized")
      end
    end
  end

  describe "DELETE destroy" do

    it "redirects to the :settings_path" do
      delete :destroy
      expect(response).to redirect_to("/settings/web_access")
    end

    it "create new shelter access token" do
      delete :destroy
      expect(current_shelter.access_token).to be_nil
    end

    context "with failed authorization" do
      it "renders the errors/unauthorized template" do
        allow(controller).to receive(:authorize!).
          with(:generate_access_token, current_shelter).
          and_raise(CanCan::AccessDenied)

        delete :destroy
        expect(response).to render_template("errors/unauthorized")
      end
    end
  end

end

