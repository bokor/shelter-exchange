require "rails_helper"

describe Admin::UsersController do
  login_owner

  describe "GET index" do

    before do
      @shelter = Shelter.gen :name => "Admin List Shelter"
      @user = User.gen :name => "Admin List User", :email => "admin_list_user@gmail.com"
      @account = Account.gen :shelters => [@shelter], :users => [@user]
    end

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
    it "assigns @users" do
      User.gen :name => "Another User", :email => "another@gmail.com", :account => @account

      get :index

      users = MultiJson.load(assigns(:users).to_json)
      expect(users).to match_array([{
        "user" => {
          "email" => "admin_list_user@gmail.com",
          "name" => "Admin List User",
          "shelter_id" => @shelter.id,
          "shelter_name" => "Admin List Shelter"
        }
      }, {
        "user" => {
          "email" => "another@gmail.com",
          "name" => "Another User",
          "shelter_id" => @shelter.id,
          "shelter_name" => "Admin List Shelter"
        }
      }])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end

    context "with pagination" do
      it "paginates users :index results" do
        allow(WillPaginate::Collection).to receive(:create).with(1, 50) { [@user] }
        get :index, :page => 1, :format => :js
        expect(assigns(:users)).to eq([@user])
      end
    end
  end

  describe "GET live_search" do

    before do
      @shelter = Shelter.gen :name => "Admin List Shelter"
      @brian = User.gen :name => "Brian Bokor", :email => "brian@gmail.com"
      @claire = User.gen :name => "Claire Bokor", :email => "claire@gmail.com"
      @account = Account.gen :shelters => [@shelter], :users => [@brian, @claire]
    end

    it "responds successfully" do
      get :live_search, :q => "", :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @users" do
      get :live_search, :q => "brian", :format => :js

      users = MultiJson.load(assigns(:users).to_json)
      expect(users).to match_array([{
        "user" => {
          "email" => "brian@gmail.com",
          "name" => "Brian Bokor",
          "shelter_id" => @shelter.id,
          "shelter_name" => "Admin List Shelter"
        }
      }])
    end

    context "with pagination" do
      it "paginates users :index results" do
        allow(WillPaginate::Collection).to receive(:create).with(1, 50) { [@brian] }
        get :live_search, :q => "brian", :page => 1, :format => :js
        expect(assigns(:users)).to eq([@brian])
      end
    end
  end
end

