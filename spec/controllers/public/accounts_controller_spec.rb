require "spec_helper"

describe Public::AccountsController do

  describe "GET new" do

    it "responds successfully" do
      get :new
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns a new account as @account" do
      get :new
      expect(assigns(:account)).to be_a_new(Account)
    end

    it "assigns a new shelter as @shelter" do
      get :new
      expect(assigns(:shelter)).to be_a_new(Shelter)
    end

    it "assigns a new user as @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "renders the :new view" do
      get :new
      expect(response).to render_template(:new)
    end

    context "when app disabled" do
      it "renders errors/app_disabled" do
        allow(ShelterExchange.settings).to receive(:app_disabled?).and_return(true)
        get :new
        expect(response).to render_template("errors/app_disabled")
      end
    end
  end

  describe "GET create" do

    before do
      file = Rack::Test::UploadedFile.new(Rails.root.join("spec/data/documents/testing.pdf"))

      user = User.build :role => "owner"
      shelter = Shelter.build
      account = Account.build :shelters => [shelter], :users => [user]

      account_attributes = account.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
      shelter_attributes = shelter.attributes.symbolize_keys.except(:created_at, :updated_at, :id, :account_id)
      user_attributes = user.attributes.symbolize_keys.except(:created_at, :updated_at, :id, :account_id, :encrypted_password)

      @attributes = account_attributes.merge(
        :document => file,
        :shelters_attributes => { "0" => shelter_attributes },
        :users_attributes => { "0" => user_attributes.merge(:password => "testing", :password_confirmation => "testing") }
      )
    end

    it "creates a new Account" do
      expect {
        post :create, :account => @attributes
      }.to change(Account, :count).by(1)
    end

    it "creates a new Shelter" do
      expect {
        post :create, :account => @attributes
      }.to change(Shelter, :count).by(1)
    end

    it "creates a new User" do
      expect {
        post :create, :account => @attributes
      }.to change(User, :count).by(1)
    end

    it "assigns a newly created account as @account" do
      post :create, :account => @attributes
      expect(assigns(:account)).to be_an(Account)
      expect(assigns(:account)).to be_persisted
    end

    it "sends account_created notification to owner" do
      post :create, :account => @attributes

      account = Account.last
      mailer = YAML.load(Delayed::Job.all[1].handler)
      expect(mailer.object).to eq(OwnerMailer)
      expect(mailer.args[0]).to eq(account)
      expect(mailer.args[1]).to eq(account.shelters.first)
      expect(mailer.args[2]).to eq(account.users.first)
      expect(mailer.method_name).to eq(:account_created)
    end

    it "sends welcome notification to the account" do
      post :create, :account => @attributes

      account = Account.last
      mailer = YAML.load(Delayed::Job.last.handler)
      expect(mailer.object).to eq(AccountMailer)
      expect(mailer.args[0]).to eq(account)
      expect(mailer.args[1]).to eq(account.shelters.first)
      expect(mailer.args[2]).to eq(account.users.first)
      expect(mailer.method_name).to eq(:welcome)
    end

    it "sets the flash message" do
      post :create, :account => @attributes
      expect(flash[:notice]).to eq("Account registered!")
    end

    it "redirects to the :registered_public_account_path" do
      post :create, :account => @attributes
      expect(response).to redirect_to(registered_public_account_path(assigns(:account)))
    end

    context "with a save error" do
      it "renders the :new view" do
        allow_any_instance_of(Account).to receive(:save).and_return(false)
        post :create, :account => @attributes
        expect(response).to render_template(:new)
      end
    end

    context "when app disabled" do
      it "renders errors/app_disabled" do
        allow(ShelterExchange.settings).to receive(:app_disabled?).and_return(true)
        post :create, :account => @attributes
        expect(response).to render_template("errors/app_disabled")
      end
    end
  end

  describe "GET registered" do

    before do
      @user = User.gen :role => "owner"
      @shelter = Shelter.gen
      @account = Account.gen :shelters => [@shelter], :users => [@user]
    end

    it "responds successfully" do
      get :registered, :id => @account.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @account" do
      get :registered, :id => @account.id
      expect(assigns(:account)).to eq(@account)
    end

    it "assigns @shelter" do
      get :registered, :id => @account.id
      expect(assigns(:shelter)).to eq(@shelter)
    end

    it "renders the :registered view" do
      get :registered, :id => @account.id
      expect(response).to render_template(:registered)
    end
  end
end
