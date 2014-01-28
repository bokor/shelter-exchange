require "spec_helper"

describe TokenAuthenticationsController do
  login_user

  describe "POST create" do

    it "responds successfully" do
      # ability = Object.new
      # ability.extend(CanCan::Ability)
      # controller.stub!(:current_ability).and_return(ability)

      post :create
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "create new shelter access token" do
      allow(SecureRandom).to receive(:hex).and_return("xxx12345xxx")

      post :create
      expect(current_shelter.access_token).to eq("xxx12345xxx")
    end

    it "redirects to the :settings_path" do
      post :create
      expect(response).to redirect_to("/settings/web_access")
    end

    context "with failed authorization" do

      it "renders the errors/unauthorized template" do
        allow(controller).to receive(:authorize!) { raise CanCan::AccessDenied }
        post :create
        expect(controller).to receive(:render)
        expect(response).to render_template("errors/unauthorize")
      end
    end
  end

  describe "DELETE destroy" do
  # def destroy
  #   @shelter = @current_shelter
  #   authorize!(:generate_access_token, @shelter)
  #   @shelter.access_token = nil
  #   @shelter.save
  #   redirect_to setting_path(:tab => :web_access)
  # end
    # before do
    #   @alert = Alert.gen :title => "Title 1", :shelter => current_shelter
    # end

    # it "responds successfully" do
    #   delete :destroy, :id => @alert.id, :format => :js
    #   expect(response).to be_success
    #   expect(response.status).to eq(200)
    # end

    # it "deletes an Alert" do
    #   expect {
    #     delete :destroy, :id => @alert.id, :format => :js
    #   }.to change(Alert, :count).by(-1)
    # end

    # it "sets the flash message" do
    #   delete :destroy, :id => @alert.id, :format => :js
    #   expect(flash[:notice]).to eq("Title 1 has been deleted.")
    # end

    # it "returns deleted @alert" do
    #   delete :destroy, :id => @alert.id, :format => :js
    #   expect(assigns(:alert)).to eq(@alert)
    # end

    # it "renders the :delete view" do
    #   delete :destroy, :id => @alert.id, :format => :js
    #   expect(response).to render_template(:destroy)
    # end

    # context "with a destroy error" do
    #   it "does not set a flash message" do
    #     Alert.any_instance.stub(:destroy).and_return(false)

    #     delete :destroy, :id => @alert.id, :format => :js
    #     expect(flash[:notice]).to be_nil
    #   end
    # end
  end

end

