require "rails_helper"

describe Api::AnimalsController do
  login_user

  describe "GET index" do

    before do
      @animal = Animal.gen \
        :shelter => current_shelter,
        :animal_status_id => AnimalStatus::STATUSES[:available_for_adoption],
        :animal_type_id => AnimalType::TYPES[:dog],
        :description => "Cute"
    end

    it "responds successfully" do
      get :index, :access_token => current_shelter.access_token
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @animals" do
      another_animal = Animal.gen(
        :shelter => current_shelter,
        :animal_status_id => AnimalStatus::STATUSES[:available_for_adoption]
      )

      get :index, :access_token => current_shelter.access_token
      expect(assigns(:animals)).to match_array([@animal, another_animal])
    end

    it "renders the :index view" do
      get :index, :access_token => current_shelter.access_token
      expect(response).to render_template(:index)
    end

    context "with json" do
      render_views

      it "renders the :index view" do
        get :index, :access_token => current_shelter.access_token, :format => :json
        expect(response).to render_template(:index)
      end

      it "renders json" do
        expect(@animal.animal_type).to receive(:name).and_return("Dog")
        expect(@animal.animal_status).to receive(:name).and_return("Available for Adoption")

        get :index, :access_token => current_shelter.access_token, :format => :json
        expect(MultiJson.load(response.body)).to match_array([
          {
            "id" => @animal.id,
            "name" => @animal.name,
            "type" => "Dog",
            "status" => "Available for Adoption",
            "breed" => {
              "mixed" => @animal.is_mix_breed,
              "primary" => @animal.primary_breed,
              "secondary" => @animal.secondary_breed,
              "full_text" => @animal.full_breed
            },
            "attributes" => {
              "sterilized" => @animal.is_sterilized,
              "age_range" => @animal.age.humanize,
              "date_of_birth" => @animal.date_of_birth,
              "date_of_birth_in_text" => "",
              "size" => "Medium",
              "color" => @animal.color,
              "weight" => @animal.weight,
              "sex" => "Male",
              "microchip" => @animal.microchip
            },
            "special_needs" => @animal.has_special_needs,
            "special_needs_description" => "<p></p>",
            "description_as_text" => @animal.description,
            "description_as_html" => "<p>Cute</p>",
            "arrival_date" => nil,
            "hold_time" => "",
            "euthanasia_date" => nil,
            "url" => "http://#{current_account.subdomain}.se.test/save_a_life/#{@animal.id}",
            "video" => @animal.video_url,
            "photos" => []
          }
        ])
      end
    end

    context "with exception in api lookup" do
      it "returns error message" do
        get :index,
            :access_token => current_shelter.access_token,
            :types => [1,2],
            :statuses => [1,13,14], :format => :json #params format incorrect
        expect(MultiJson.load(response.body)).to eq(
          {"error" => "Unexpected error has occurred.  Please review the API documentation to make sure everything is correct."}
        )
      end
    end

    context "with incorrect types or statuses" do
      it "returns error message" do
        get :index,
            :access_token => current_shelter.access_token,
            :types => "[1,2]",
            :statuses => "[1,13,14]", :format => :json
        expect(MultiJson.load(response.body)).to eq(
          {"error" => "Contains Animal Types or Statuses that are not allowed.  Please refer to the help documentation to resolve this issue."}
        )
      end
    end

    context "with pagination" do
      it "paginates :index results" do
        animal = Animal.gen :name => "paginated_animals", :shelter => current_shelter
        allow(WillPaginate::Collection).to receive(:create).with(1, 15) { [animal] }

        get :index, :access_token => current_shelter.access_token, :page => 1

        expect(assigns(:animals)).to eq([animal])
      end
    end
  end

  describe "GET search" do

    before do
      @animal1 = Animal.gen :shelter => current_shelter, :animal_status_id => 1, :primary_breed => "Lab"
      @animal2 = Animal.gen :shelter => current_shelter, :animal_status_id => 1
      @animal3 = Animal.gen :shelter => current_shelter, :animal_status_id => 2
    end

    it "responds successfully" do
      get :search, :access_token => current_shelter.access_token, :filters => {}, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :search view" do
      get :search, :access_token => current_shelter.access_token, :filters => {}, :format => :js
      expect(response).to render_template(:search)
    end

    it "assigns @animals" do
      get :search, :access_token => current_shelter.access_token, :filters => {}, :format => :js
      expect(assigns(:animals)).to eq([@animal1, @animal2])
    end

    context "with filters" do
      it "assigns @animals" do
        get :search, :access_token => current_shelter.access_token, :filters => {:breed => "Lab"}, :format => :js
        expect(assigns(:animals)).to eq([@animal1])
      end
    end

    context "with pagination" do
      it "paginates :search results" do
        allow(WillPaginate::Collection).to receive(:create).with(1, 15) { [@animal1] }

        get :search, :access_token => current_shelter.access_token, :filters => {}, :page => 1, :format => :js
        expect(assigns(:animals)).to eq([@animal1])

      end
    end
  end
end


