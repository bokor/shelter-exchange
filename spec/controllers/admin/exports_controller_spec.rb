require "spec_helper"

describe Admin::ExportsController do
  login_owner

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
  end

  describe "GET show" do

    it "responds successfully" do
      get :show, :export_type => :all_emails, :format => :csv
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    context "with all_emails export type" do

      before do
        Timecop.freeze(Time.parse("Mon, 12 May 2014"))

        Shelter.gen :status => "cancelled"
        Shelter.gen :name => "Another Shelter", :email => "another_shelter@gmail.com"

        @shelter = Shelter.gen :name => "Doggie Rescue", :email => "shelter@gmail.com"
        @user = User.gen :name => "Brian", :email => "brian@gmail.com"
        Account.gen(:shelters => [@shelter], :users => [@user])
      end

      it "sends csv file" do
        get :show, :export_type => :all_emails, :format => :csv

        expect(response.headers).to include({
          "Content-Disposition" => "attachment; filename=\"all_emails.csv\"",
          "Content-Type" => "text/csv"
        })

        csv_file = CSV.parse(response.body)
        expect(csv_file).to match_array([
          ["shelter@gmail.com", "Doggie Rescue", "2014-05-12"],
          ["brian@gmail.com", "Doggie Rescue", "2014-05-12"],
          ["another_shelter@gmail.com", "Another Shelter", "2014-05-12"]
        ])
      end
    end

    context "with petfinder_emails export type" do

      before do
        Timecop.freeze(Time.parse("Mon, 12 May 2014"))

        @shelter = Shelter.gen :name => "Doggie Rescue", :email => "shelter@gmail.com"
        @user = User.gen :name => "Brian", :email => "brian@gmail.com"
        Account.gen(:shelters => [@shelter], :users => [@user])

        Integration.gen :type => "Integration::Petfinder", :shelter => @shelter
        Integration.gen :type => "Integration::AdoptAPet", :shelter => Shelter.gen
        Integration.gen :type => "Integration::Petfinder", :shelter => Shelter.gen(:status => "cancelled")
      end

      it "sends csv file" do
        get :show, :export_type => :petfinder_emails, :format => :csv

        expect(response.headers).to include({
          "Content-Disposition" => "attachment; filename=\"petfinder_emails.csv\"",
          "Content-Type" => "text/csv"
        })

        csv_file = CSV.parse(response.body)
        expect(csv_file).to match_array([
          ["shelter@gmail.com", "Doggie Rescue", "2014-05-12"],
          ["brian@gmail.com", "Doggie Rescue", "2014-05-12"],
        ])
      end
    end

    context "with adopt_a_pet_emails export type" do

      before do
        Timecop.freeze(Time.parse("Mon, 12 May 2014"))

        @shelter = Shelter.gen :name => "Doggie Rescue", :email => "shelter@gmail.com"
        @user = User.gen :name => "Brian", :email => "brian@gmail.com"
        Account.gen(:shelters => [@shelter], :users => [@user])

        Integration.gen :type => "Integration::AdoptAPet", :shelter => @shelter
        Integration.gen :type => "Integration::Petfinder", :shelter => Shelter.gen
        Integration.gen :type => "Integration::AdoptAPet", :shelter => Shelter.gen(:status => "cancelled")
      end

      it "sends csv file" do
        get :show, :export_type => :adopt_a_pet_emails, :format => :csv

        expect(response.headers).to include({
          "Content-Disposition" => "attachment; filename=\"adopt_a_pet_emails.csv\"",
          "Content-Type" => "text/csv"
        })

        csv_file = CSV.parse(response.body)
        expect(csv_file).to match_array([
          ["shelter@gmail.com", "Doggie Rescue", "2014-05-12"],
          ["brian@gmail.com", "Doggie Rescue", "2014-05-12"],
        ])
      end
    end

    context "with all_integrations_emails export type" do

      before do
        Timecop.freeze(Time.parse("Mon, 12 May 2014"))

        @shelter = Shelter.gen :name => "Doggie Rescue", :email => "shelter@gmail.com"
        @user = User.gen :name => "Brian", :email => "brian@gmail.com"
        Account.gen(:shelters => [@shelter], :users => [@user])

        @another_shelter = Shelter.gen :name => "Another Shelter", :email => "another_shelter@gmail.com"

        Integration.gen :type => "Integration::AdoptAPet", :shelter => @shelter
        Integration.gen :type => "Integration::Petfinder", :shelter => @shelter
        Integration.gen :type => "Integration::Petfinder", :shelter => @another_shelter
        Integration.gen :type => "Integration::AdoptAPet", :shelter => Shelter.gen(:status => "cancelled")
      end

      it "sends csv file" do
        get :show, :export_type => :all_integrations_emails, :format => :csv

        expect(response.headers).to include({
          "Content-Disposition" => "attachment; filename=\"all_integrations_emails.csv\"",
          "Content-Type" => "text/csv"
        })

        csv_file = CSV.parse(response.body)
        expect(csv_file).to match_array([
          ["another_shelter@gmail.com", "Another Shelter", "2014-05-12"],
          ["brian@gmail.com", "Doggie Rescue", "2014-05-12"],
          ["shelter@gmail.com", "Doggie Rescue", "2014-05-12"]
        ])
      end
    end

    context "with signed_up_last_thirty_days_emails export type" do

      before do
        Shelter.gen :name => "Rescue now", :email => "rescue_now@gmail.com", :created_at => Time.zone.today - 1.day
        Shelter.gen :name => "Rescue 30 days ago", :email => "rescue_30_days_ago@gmail.com", :created_at => Time.zone.today - 30.days
        Shelter.gen :name => "Shelter", :email => "shelter@gmail.com", :created_at => Time.zone.today - 45.days
      end

      it "sends csv file" do
        get :show, :export_type => :signed_up_last_thirty_days_emails, :format => :csv

        expect(response.headers).to include({
          "Content-Disposition" => "attachment; filename=\"signed_up_last_thirty_days_emails.csv\"",
          "Content-Type" => "text/csv"
        })

        csv_file = CSV.parse(response.body)
        expect(csv_file).to match_array([
          ["rescue_30_days_ago@gmail.com", "Rescue 30 days ago", (Time.zone.today - 30.days).strftime("%Y-%m-%d")],
          ["rescue_now@gmail.com", "Rescue now", (Time.zone.today - 1.day).strftime("%Y-%m-%d")]
        ])
      end
    end

    context "with not_used_past_thirty_days_emails export type" do

      before do
        @shelter_not_using = Shelter.gen :name => "Doggie Rescue", :email => "doggie_rescue@gmail.com"
        @user_not_using = User.gen :name => "Brian", :email => "brian@gmail.com", :current_sign_in_at => 45.days.ago
        Account.gen(:shelters => [@shelter_not_using], :users => [@user_not_using])

        @shelter_using = Shelter.gen :name => "Rescue", :email => "rescue@gmail.com"
        @user_using = User.gen :name => "me", :email => "me@gmail.com", :current_sign_in_at => 15.days.ago
        Account.gen(:shelters => [@shelter_using], :users => [@user_using])

        @cancelled_shelter = Shelter.gen :status => "cancelled"
        @cancelled_user = User.gen :current_sign_in_at => 15.days.ago
        Account.gen(:shelters => [@cancelled_shelter], :users => [@cancelled_user])
      end

      it "sends csv file" do
        get :show, :export_type => :not_used_past_thirty_days_emails, :format => :csv

        expect(response.headers).to include({
          "Content-Disposition" => "attachment; filename=\"not_used_past_thirty_days_emails.csv\"",
          "Content-Type" => "text/csv"
        })

        csv_file = CSV.parse(response.body)
        expect(csv_file).to match_array([
          ["brian@gmail.com", "Doggie Rescue", @user_not_using.created_at.strftime("%Y-%m-%d")],
          ["doggie_rescue@gmail.com", "Doggie Rescue", @shelter_not_using.created_at.strftime("%Y-%m-%d")],
        ])
      end
    end

    context "with web_token_emails export type" do

      before do
        Timecop.freeze(Time.parse("Mon, 12 May 2014"))

        @shelter = Shelter.gen :name => "Doggie Rescue", :email => "shelter@gmail.com", :access_token => "1234"
        @user = User.gen :name => "Brian", :email => "brian@gmail.com"
        Account.gen(:shelters => [@shelter], :users => [@user])

        @another_shelter = Shelter.gen :name => "Another Shelter", :email => "another_shelter@gmail.com", :access_token => nil
      end

      it "sends csv file" do
        get :show, :export_type => :web_token_emails, :format => :csv

        expect(response.headers).to include({
          "Content-Disposition" => "attachment; filename=\"web_token_emails.csv\"",
          "Content-Type" => "text/csv"
        })

        csv_file = CSV.parse(response.body)
        expect(csv_file).to match_array([
          ["brian@gmail.com", "Doggie Rescue", "2014-05-12"],
          ["shelter@gmail.com", "Doggie Rescue", "2014-05-12"]
        ])
      end
    end
  end
end

