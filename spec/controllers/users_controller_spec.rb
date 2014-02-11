require "spec_helper"

describe UsersController do
  login_user

  describe "GET index" do

    before do
      @user = User.gen :account => current_account
    end

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @users" do
      get :index
      expect(assigns(:users)).to match_array([current_user, @user])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET edit" do

    before do
      @user = User.gen :account => current_account
    end

    it "responds successfully" do
      get :edit, :id => @user.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @user" do
      get :edit, :id => @user.id, :format => :js
      expect(assigns(:user)).to eq(@user)
    end

    it "renders the :edit view" do
      get :edit, :id => @user.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT update" do

    before do
      @user = User.gen :name => "Billy Bob", :account => current_account
      @update_attrs = { :name => "Jimmy Joe" }
    end

    it "updates an User" do
      expect {
        put :update, :id => @user.id, :user => @update_attrs
        @user.reload
      }.to change(@user, :name).to("Jimmy Joe")
    end

    it "assigns @user" do
      put :update, :id => @user.id, :user => @update_attrs
      expect(assigns(:user)).to be_a(User)
      expect(assigns(:user)).to be_persisted
    end

    it "assigns @current_ability" do
      put :update, :id => @user.id, :user => @update_attrs
      expect(assigns(:current_ability)).to be_nil
    end

    it "sets the flash message" do
      put :update, :id => @user.id, :user => @update_attrs
      expect(flash[:notice]).to eq("Jimmy Joe has been updated.")
    end

    it "redirects to :users_path" do
      put :update, :id => @user.id, :user => @update_attrs
      expect(response).to redirect_to(users_path)
    end

    it "renders :update view" do
      put :update, :id => @user.id, :user => @update_attrs, :format => :js
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "does not set a flash message" do
        allow_any_instance_of(User).to receive(:update_attributes).and_return(false)

        put :update, :id => @user.id, :user => @update_attrs
        expect(flash[:error]).to eq("Error in updating Billy Bob.  Please try again!")
      end

      it "renders :index view" do
        allow_any_instance_of(User).to receive(:update_attributes).and_return(false)

        put :update, :id => @user.id, :user => @update_attrs
        expect(response).to render_template(:index)
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @user = User.gen :name => "Billy Bob", :account => current_account
    end

    it "responds successfully" do
      delete :destroy, :id => @user.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an User" do
      expect {
        delete :destroy, :id => @user.id, :format => :js
      }.to change(User, :count).by(-1)
    end

    it "sets the flash message" do
      delete :destroy, :id => @user.id, :format => :js
      expect(flash[:notice]).to eq("Billy Bob has been deleted.")
    end

    it "assigns @user" do
      delete :destroy, :id => @user.id, :format => :js
      expect(assigns(:user)).to eq(@user)
    end

    it "renders the :delete view" do
      delete :destroy, :id => @user.id, :format => :js
      expect(response).to render_template(:destroy)
    end

    context "with a destroy error" do
      it "does not set a flash message" do
        allow_any_instance_of(User).to receive(:destroy).and_return(false)

        delete :destroy, :id => @user.id, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "PUT change_password" do

    before do
      @user = User.gen :account => current_account
      @update_attrs = {
        :current_password => @user.password,
        :password => "xx12345xx",
        :password_confirmation => "xx12345xx"
      }
    end

    it "updates a User's password" do
      expect_any_instance_of(User).to receive(:update_with_password).with(@update_attrs.stringify_keys!)
# not sure how to test         sign_in(:user, @user, :bypass => true)
      put :change_password, :id => @user.id, :user => @update_attrs, :format => :js
    end

    it "assigns @user" do
      put :change_password, :id => @user.id, :user => @update_attrs, :format => :js
      expect(assigns(:user)).to be_a(User)
      expect(assigns(:user)).to be_persisted
    end

    it "assigns @current_ability" do
      put :change_password, :id => @user.id, :user => @update_attrs, :format => :js
      expect(assigns(:current_ability)).to be_nil
    end

    it "sets the flash message" do
      put :change_password, :id => @user.id, :user => @update_attrs, :format => :js
      expect(flash[:notice]).to eq("Your password has been changed.")
    end

    it "redirects to :users_path" do
      put :change_password, :id => @user.id, :user => @update_attrs
      expect(response).to redirect_to(users_path)
    end

    it "renders :change_password view" do
      put :change_password, :id => @user.id, :user => @update_attrs, :format => :js
      expect(response).to render_template(:change_password)
    end

    context "with a save error" do
      it "does not set a flash message" do
        allow_any_instance_of(User).to receive(:update_attributes).and_return(false)

        put :change_password, :id => @user.id, :user => @update_attrs, :format => :js
        expect(flash[:error]).to eq("Error in updating password.  Please try again!")
      end

      it "renders :index view" do
        allow_any_instance_of(User).to receive(:update_attributes).and_return(false)

        put :change_password, :id => @user.id, :user => @update_attrs
        expect(response).to render_template(:index)
      end
    end
  end

  describe "POST change_owner" do

    before do
      @new_owner = User.gen :name => "Billy Owner", :account => current_account, :role => "admin"
    end

    it "assigns @current_owner" do
      post :change_owner, :id => current_user.id, :new_owner_id => @new_owner.id
      expect(assigns(:current_owner)).to be_a(User)
      expect(assigns(:current_owner)).to be_persisted
    end

    it "assigns @new_owner" do
      post :change_owner, :id => current_user.id, :new_owner_id => @new_owner.id
      expect(assigns(:new_owner)).to be_a(User)
      expect(assigns(:new_owner)).to be_persisted
    end

    it "assigns @current_ability" do
      post :change_owner, :id => current_user.id, :new_owner_id => @new_owner.id
      expect(assigns(:current_ability)).to be_nil
    end

    it "updates new owner to owner role" do
      expect {
        post :change_owner, :id => current_user.id, :new_owner_id => @new_owner.id
        @new_owner.reload
      }.to change(@new_owner, :role).to("owner")
    end

    it "updates old owner to admin role" do
      expect {
        post :change_owner, :id => current_user.id, :new_owner_id => @new_owner.id
        current_user.reload
      }.to change(current_user, :role).to("admin")
    end

    it "sets the flash message" do
      post :change_owner, :id => current_user.id, :new_owner_id => @new_owner.id
      expect(flash[:notice]).to eq("Owner has been changed to Billy Owner.")
    end

    it "redirects to :settings_path" do
      post :change_owner, :id => current_user.id, :new_owner_id => @new_owner.id
      expect(response).to redirect_to(settings_path)
    end

    context "with the same user" do
      it "set a warning flash message" do
        post :change_owner, :id => @new_owner.id, :new_owner_id => @new_owner.id
        expect(flash[:warning]).to eq("Owner did not change because the same user was selected")
      end
    end
  end

  describe "POST invite" do

    before do
      user = User.build :account => current_account
      @attributes = user.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "assigns @user" do
      post :invite, :user => @attributes, :format => :js
      expect(assigns(:user)).to be_a(User)
      expect(assigns(:user)).to be_persisted
    end

    it "invite user" do
      expect(User).to receive(:invite!).with(@attributes.stringify_keys!)
      post :invite, :user => @attributes, :format => :js
    end

    it "renders :invite view" do
      post :invite, :user => @attributes, :format => :js
      expect(response).to render_template(:invite)
    end
  end

  describe "GET valid_token" do

    before do
      @user = User.gen :account => current_account, :authentication_token => "auth_token"
    end

    it "login user from auth token" do
      expect(User).to receive(:valid_token?).with("auth_token")
# not sure how to test       sign_in(:user, token_user)
      get :valid_token, :id => "auth_token"
    end

    it "does not authenticate user" do
      expect(controller).not_to receive(:authenticate_user!)
      get :valid_token, :id => "auth_token"
    end

    it "sets the flash message" do
      get :valid_token, :id => "auth_token"
      expect(flash[:notice]).to eq("You have been logged in")
    end

    it "redirects to :root" do
      get :valid_token, :id => "auth_token"
      expect(response).to redirect_to(:root)
    end

    context "when user lookup fails" do
      it "sets the flash meessage" do
        get :valid_token, :id => "token_fails"
        expect(flash[:alert]).to eq("Login could not be validated")
      end
    end
  end
end

