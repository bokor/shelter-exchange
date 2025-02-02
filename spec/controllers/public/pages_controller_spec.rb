require "rails_helper"

describe Public::PagesController do

  describe "GET index" do

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @animals" do
      Animal.gen(:animal_status_id => 2, :status_history_date_month => "01", :status_history_date_day => "02", :status_history_date_year => "2015")
      animal2 = Animal.gen(:animal_status_id => 2, :status_history_date_month => "01", :status_history_date_day => "03", :status_history_date_year => "2015")
      animal3 = Animal.gen(:animal_status_id => 2, :status_history_date_month => "01", :status_history_date_day => "04", :status_history_date_year => "2015")
      animal4 = Animal.gen(:animal_status_id => 2, :status_history_date_month => "01", :status_history_date_day => "05", :status_history_date_year => "2015")

      get :index
      expect(assigns(:animals)).to match_array([animal4, animal3, animal2])
    end

    it "assigns @lives_saved" do
      Animal.gen :animal_status_id => AnimalStatus::STATUSES[:adopted]
      Animal.gen :animal_status_id => AnimalStatus::STATUSES[:transferred]
      Animal.gen :animal_status_id => AnimalStatus::STATUSES[:available_for_adoption]

      get :index
      expect(assigns(:lives_saved)).to eq(2)
    end

    it "assigns @active_shelters" do
      Shelter.gen :status => "active"
      Shelter.gen :status => "cancelled"

      get :index
      expect(assigns(:active_shelters)).to eq(1)
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET show" do

    it "responds successfully" do
      get :show, :path => "index"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :index view" do
      get :show, :path => "index"
      expect(response).to render_template(:index)
    end

    context "when path is a directory" do

      it "responds successfully" do
        get :show, :path => "contact_us"
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it "renders the :contact_us/index view" do
        get :show, :path => "contact_us"
        expect(response).to render_template("contact_us/index")
      end
    end

    context "with file or directory does not exist" do

      it "responds with 404" do
        get :show, :path => "blah_blah_blah"
        expect(response.status).to eq(404)
      end

      it "renders the :public/404 view" do
        get :show, :path => "blah_blah_blah"
        expect(response).to render_template(:file => "public/404")
      end
    end
  end

  describe "GET sitemap" do

    it "responds with 301" do
      get :sitemap, :format => :xml
      expect(response.status).to eq(301)
    end

    it "redirects to sitemap xml" do
      get :sitemap, :format => :xml
      expect(response).to redirect_to("http://s3.amazonaws.com/shelterexchange/sitemaps/sitemap.xml.gz")
    end
  end
end

