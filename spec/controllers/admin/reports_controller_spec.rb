require "rails_helper"

describe Admin::ReportsController do
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

  describe "GET status_by_month_year" do

    it "responds successfully" do
      get :status_by_month_year, :format => :json
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders json" do
      animal_status1 = AnimalStatus.gen :name => "Available"
      animal_status2 = AnimalStatus.gen :name => "Not Available"
      Animal.gen :animal_status => animal_status1
      Animal.gen :animal_status => animal_status2

      get :status_by_month_year, :selected_month => Date.today.month, :selected_year => Date.today.year, :format => :json
      expect(MultiJson.load(response.body)).to match_array([
        { "name" => "Available", "count" => 1 },
        { "name" => "Not Available", "count" => 1 }
      ])
    end
  end

  describe "GET type_by_month_year" do

    it "responds successfully" do
      get :type_by_month_year, :format => :json
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders json" do
      Timecop.freeze(Time.parse("Fri, 14 Feb 2014"))

      animal_type1 = AnimalType.gen :name => "Dog"
      animal_type2 = AnimalType.gen :name => "Cat"
      Animal.gen :animal_type => animal_type1, :animal_status_id => AnimalStatus::ACTIVE[0]
      Animal.gen :animal_type => animal_type2, :animal_status_id => AnimalStatus::NON_ACTIVE[0]

      get :type_by_month_year, :selected_month => "02", :selected_year => "2014", :format => :json

      expect(MultiJson.load(response.body)).to match_array([
        { "name" => "Dog", "count" => 1 },
        { "name" => "Cat", "count" => 1 }
      ])
    end
  end

  describe "GET custom" do

    it "responds successfully" do
      get :custom
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders :custom view" do
      get :custom
      expect(response).to render_template(:custom)
    end

    context "with combined totals" do
      it "renders json when by_type true" do
        Timecop.freeze(Time.parse("Fri, 14 Feb 2014"))

        animal_type1 = AnimalType.gen :name => "Dog"
        animal_type2 = AnimalType.gen :name => "Cat"
        Animal.gen :animal_type => animal_type1, :animal_status_id => AnimalStatus::STATUSES[:adopted]
        Animal.gen :animal_type => animal_type1, :animal_status_id => AnimalStatus::STATUSES[:available_for_adoption]
        Animal.gen :animal_type => animal_type2, :animal_status_id => AnimalStatus::STATUSES[:adopted]

        get :custom, :status => "adopted", :by_type => "false", :format => :json

        expect(MultiJson.load(response.body)).to match_array([
          {
            "type" => "Total",
            "jan" => 0, "feb" => 2, "mar" => 0, "apr" => 0, "may" => 0, "jun" => 0,
            "jul" => 0, "aug" => 0, "sep" => 0, "oct" => 0, "nov" => 0, "dec" => 0
          }
        ])
      end
    end

    context "with totals by animal type" do

      it "renders json" do
        Timecop.freeze(Time.parse("Fri, 14 Feb 2014"))

        animal_type1 = AnimalType.gen :name => "Dog"
        animal_type2 = AnimalType.gen :name => "Cat"
        Animal.gen :animal_type => animal_type1, :animal_status_id => AnimalStatus::STATUSES[:adopted]
        Animal.gen :animal_type => animal_type2, :animal_status_id => AnimalStatus::STATUSES[:adopted]

        get :custom, :status => "adopted", :by_type => "true", :format => :json

        expect(MultiJson.load(response.body)).to match_array([
          {
            "type" => "Dog",
            "jan" => 0, "feb" => 1, "mar" => 0, "apr" => 0, "may" => 0, "jun" => 0,
            "jul" => 0, "aug" => 0, "sep" => 0, "oct" => 0, "nov" => 0, "dec" => 0
          }, {
            "type" => "Cat",
            "jan" => 0, "feb" => 1, "mar" => 0, "apr" => 0, "may" => 0, "jun" => 0,
            "jul" => 0, "aug" => 0, "sep" => 0, "oct" => 0, "nov" => 0, "dec" => 0
          }
        ])
      end
    end

    context "with no parameters" do

      it "renders json" do
        get :custom, :format => :json

        expect(MultiJson.load(response.body)).to match_array([
          {
            "type" => "Total",
            "jan" => 0, "feb" => 0, "mar" => 0, "apr" => 0, "may" => 0, "jun" => 0,
            "jul" => 0, "aug" => 0, "sep" => 0, "oct" => 0, "nov" => 0, "dec" => 0
          }
        ])
      end
    end
  end
end
