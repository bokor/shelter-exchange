require "rails_helper"

describe AnimalsController do
  login_user

  describe "GET index" do

    before do
      @animal = Animal.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "responds successfully with js format" do
      get :index, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @total_animals" do
      Animal.gen :shelter => current_shelter, :animal_status_id => AnimalStatus::ACTIVE[0]

      get :index
      expect(assigns(:total_animals)).to eq(2)
    end

    it "assigns @animals" do
      @animal.update_attribute(:animal_status_id, AnimalStatus::ACTIVE[0])
      another_animal = Animal.gen :shelter => current_shelter, :animal_status_id => AnimalStatus::ACTIVE[0]
      Animal.gen :shelter => current_shelter, :animal_status_id => AnimalStatus::NON_ACTIVE[0]

      get :index
      expect(assigns(:animals)).to match_array([@animal, another_animal])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end

    context "with pagination" do
      it "paginates :index results" do
        animal = Animal.gen :name => "paginated_animals", :shelter => current_shelter
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [animal] }

        get :index, :page => 1, :format => :js

        expect(assigns(:animals)).to eq([animal])
      end
    end
  end

  describe "GET show" do

    before do
      @animal = Animal.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :show, :id => @animal.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @animal" do
      get :show, :id => @animal.id
      expect(assigns(:animal)).to eq(@animal)
    end

    it "assigns @photos" do
      photo = Photo.gen :attachable => @animal

      get :show, :id => @animal.id
      expect(assigns(:photos)).to eq([photo])
    end

    it "assigns @gallery_photos" do
      Photo.gen :attachable => @animal
      get :show, :id => @animal.id
      expect(assigns(:gallery_photos)).to eq(PhotoPresenter.as_gallery_collection(assigns(:photos)))
    end

    it "assigns @uploader_photos" do
      Photo.gen :attachable => @animal
      get :show, :id => @animal.id
      expect(assigns(:uploader_photos)).to eq(PhotoPresenter.as_uploader_collection(assigns(:photos)))
    end

    it "assigns @notes" do
      note = Note.gen :notable => @animal
      get :show, :id => @animal.id
      expect(assigns(:notes)).to eq([note])
    end

    it "assigns @status_histories" do
      get :show, :id => @animal.id
      expect(assigns(:status_histories)).to eq(@animal.status_histories)
    end

    it "assigns @overdue_tasks" do
      task = Task.gen :due_date => Date.today - 1.day, :taskable => @animal
      get :show, :id => @animal.id
      expect(assigns(:overdue_tasks)).to eq([task])
    end

    it "assigns @today_tasks" do
      task = Task.gen :due_date => Date.today, :taskable => @animal
      get :show, :id => @animal.id
      expect(assigns(:today_tasks)).to eq([task])
    end

    it "assigns @tomorrow_tasks" do
      task = Task.gen :due_date => Date.today + 1.day, :taskable => @animal
      get :show, :id => @animal.id
      expect(assigns(:tomorrow_tasks)).to eq([task])
    end

    it "assigns @later_tasks" do
      task = Task.gen :due_date => Date.today + 2.day, :taskable => @animal
      get :show, :id => @animal.id
      expect(assigns(:later_tasks)).to eq([task])
    end

    it "renders the :show view" do
      get :show, :id => @animal.id
      expect(response).to render_template(:show)
    end

    context "with a record not found error" do
      it "set a flash message" do
        get :show, :id => "123abc"
        expect(flash[:error]).to eq("You have requested an invalid animal!")
      end

      it "redirects to the :animals_path" do
        get :show, :id => "123abc"
        expect(response).to redirect_to(animals_path)
      end
    end
  end

  describe "GET edit" do

    before do
      @animal = Animal.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :edit, :id => @animal.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @animal" do
      get :edit, :id => @animal.id
      expect(assigns(:animal)).to eq(@animal)
    end

    it "renders the :edit view" do
      get :edit, :id => @animal.id
      expect(response).to render_template(:edit)
    end
  end

  describe "GET new" do

    it "responds successfully" do
      get :new
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns a new animal as @animal" do
      get :new
      expect(assigns(:animal)).to be_a_new(Animal)
    end

    it "renders the :new view" do
      get :new
      expect(response).to render_template(:new)
    end

    context "with parameters" do

      it "assigns a new animal as @animal" do
        get :new, :animal => { :name => "Billy", :animal_status_id => "2", :animal_type_id => "3" }
        expect(assigns(:animal)).to be_a_new(Animal)
        expect(assigns(:animal).name).to eq("Billy")
        expect(assigns(:animal).animal_status_id).to eq(2)
        expect(assigns(:animal).animal_type_id).to eq(3)
      end
    end
  end

  describe "POST create" do

    before do
      animal = Animal.build :name => "Billy", :shelter => current_shelter
      @attributes = animal.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "creates a new Animal" do
      expect {
        post :create, :animal => @attributes
      }.to change(Animal, :count).by(1)
    end

    it "assigns a newly created animal as @animal" do
      post :create, :animal => @attributes
      expect(assigns(:animal)).to be_a(Animal)
      expect(assigns(:animal)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :animal => @attributes
      expect(flash[:notice]).to eq("Billy has been created.")
    end

    it "redirects to the :animal_path" do
      post :create, :animal => @attributes
      expect(response).to redirect_to(animal_path(assigns(:animal)))
    end

    context "with a save error" do
      it "redirects to :animals_path" do
        allow_any_instance_of(Animal).to receive(:save).and_return(false)

        post :create, :animal => @attributes
        expect(response).to redirect_to(animals_path)
      end
    end
  end

  describe "PUT update" do

    before do
      @animal = Animal.gen :name => "Billy", :shelter => current_shelter
      @update_attrs = { :name => "Jimmy" }
    end

    it "updates an Animal" do
      expect {
        put :update, :id => @animal.id, :animal => @update_attrs
        @animal.reload
      }.to change(@animal, :name).to("Jimmy")
    end

    it "assigns @animal" do
      put :update, :id => @animal.id, :animal => @update_attrs
      expect(assigns(:animal)).to be_a(Animal)
      expect(assigns(:animal)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @animal.id, :animal => @update_attrs
      expect(flash[:notice]).to eq("Jimmy has been updated.")
    end

    it "redirects to :animal_path" do
      put :update, :id => @animal.id, :animal => @update_attrs
      expect(response).to redirect_to(animal_path(@animal))
    end

    context "with a save error" do
      it "redirects to :animal_path" do
        allow_any_instance_of(Animal).to receive(:update_attributes).and_return(false)

        put :update, :id => @animal.id, :animal => @update_attrs
        expect(response).to redirect_to(animal_path(@animal))
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @animal = Animal.gen :name => "Billy", :shelter => current_shelter
    end

    it "responds successfully" do
      delete :destroy, :id => @animal.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Animal" do
      expect {
        delete :destroy, :id => @animal.id
      }.to change(Animal, :count).by(-1)
    end

    it "sets the flash message" do
      delete :destroy, :id => @animal.id
      expect(flash[:notice]).to eq("Billy has been deleted.")
    end

    it "assigns @animal" do
      delete :destroy, :id => @animal.id
      expect(assigns(:animal)).to eq(@animal)
    end

    it "renders the :delete view" do
      delete :destroy, :id => @animal.id, :format => :js
      expect(response).to render_template(:destroy)
    end

    it "redirects to :animals_path" do
      delete :destroy, :id => @animal.id
      expect(response).to redirect_to(animals_path)
    end

    context "with a destroy error" do
      it "does not set a flash message" do
        allow_any_instance_of(Animal).to receive(:destroy).and_return(false)

        delete :destroy, :id => @animal.id
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "GET search" do

    before do
      @animal1 = Animal.gen :name => "search_test", :shelter => current_shelter, :animal_status_id => AnimalStatus::NON_ACTIVE[0]
      @animal2 = Animal.gen :name => "test_search", :shelter => current_shelter, :animal_status_id => AnimalStatus::NON_ACTIVE[0]
      @animal3 = Animal.gen :shelter => current_shelter, :animal_status_id => AnimalStatus::ACTIVE[0]
    end

    it "responds successfully" do
      get :search, :q => "", :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @animals" do
      get :search, :q => "search", :format => :js
      expect(assigns(:animals)).to match_array([@animal1, @animal2])
    end

    it "renders the :search view" do
      get :search, :q => "", :format => :js
      expect(response).to render_template(:search)
    end

    context "with no parameters" do
      it "assigns @animals" do
        get :search, :q => "", :format => :js
        expect(assigns(:animals)).to eq([@animal3])
      end
    end

    context "with pagination" do
      it "paginates :search results" do
        animal = Animal.gen :name => "paginated_search", :shelter => current_shelter
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [animal] }

        get :search, :q => "paginated_search", :page => 1, :format => :js
        expect(assigns(:animals)).to eq([animal])
      end
    end
  end

  describe "GET filter_by_type_status" do

    before do
      @animal1 = Animal.gen :shelter => current_shelter
      @animal2 = Animal.gen :shelter => current_shelter
      @animal_type_id = @animal1.animal_type_id
      @animal_status_id = @animal1.animal_status_id
    end

    it "responds successfully" do
      get :filter_by_type_status, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @animals" do
      get :filter_by_type_status, :animal_type_id => @animal_type_id, :animal_status_id => @animal_status_id, :format => :js
      expect(assigns(:animals)).to eq([@animal1])
    end

    it "renders the :filter_by_type_status view" do
      get :filter_by_type_status, :format => :js
      expect(response).to render_template(:filter_by_type_status)
    end

    context "with no parameters" do
      it "assigns @animals" do
        get :filter_by_type_status, :format => :js
        expect(assigns(:animals)).to match_array([@animal1, @animal2])
      end
    end

    context "with pagination" do
      it "paginates :filter_by_type_status results" do
        animal = Animal.gen :name => "paginated_search", :shelter => current_shelter
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [animal] }

        get :filter_by_type_status, :page => 1, :format => :js
        expect(assigns(:animals)).to eq([animal])
      end
    end
  end

  describe "GET auto_complete" do

    before do
      @animal1 = Animal.gen :name => "Billy", :shelter => current_shelter
      @animal2 = Animal.gen :name => "Billy Joe", :shelter => current_shelter
    end

    it "responds successfully" do
      get :auto_complete, :q => "billy", :format => :json
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @animals" do
      get :auto_complete, :q => "billy", :format => :json
      expect(assigns(:animals)).to match_array([@animal1, @animal2])
    end

    it "renders json" do
      get :auto_complete, :q => "billy", :format => :json
      expect(MultiJson.load(response.body)).to match_array([
        { "id" => @animal1.id, "name" => "Billy" },
        { "id" => @animal2.id, "name" => "Billy Joe" }
      ])
    end

    context "without an animal type" do
      it "returns without results" do
        get :auto_complete, :q => "", :format => :json
        expect(MultiJson.load(response.body)).to eq([])
      end
    end
  end

  describe "GET filter_notes" do

    before do
      @animal = Animal.gen :shelter => current_shelter
      @general_note = Note.gen :category => "general", :notable => @animal
      @medical_note = Note.gen :category => "medical", :notable => @animal
    end

    it "responds successfully" do
      get :filter_notes, :id => @animal.id, :filter => "", :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :filter_notes view" do
      get :filter_notes, :id => @animal.id, :filter => "", :format => :js
      expect(response).to render_template(:filter_notes)
    end

    it "assigns @animal" do
      get :filter_notes, :id => @animal.id, :filter => "", :format => :js
      expect(assigns(:animal)).to eq(@animal)
    end

    it "assigns @notes" do
      get :filter_notes, :id => @animal.id, :filter => "general", :format => :js
      expect(assigns(:notes)).to eq([@general_note])
    end

    context "with no parameters" do
      it "assigns @notes" do
        get :filter_notes, :id => @animal.id, :filter => "", :format => :js
        expect(assigns(:notes)).to match_array([@general_note, @medical_note])
      end
    end
  end

  describe "GET find_animals_by_name" do

    before do
      @animal1 = Animal.gen :name => "Billy", :shelter => current_shelter
      @animal2 = Animal.gen :name => "Jimmy", :shelter => current_shelter
    end

    it "responds successfully" do
      get :find_animals_by_name, :q => "", :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :find_animals_by_name view" do
      get :find_animals_by_name, :q => "", :format => :js
      expect(response).to render_template(:find_animals_by_name)
    end

    it "assigns @animals" do
      get :find_animals_by_name, :q => "billy", :format => :js
      expect(assigns(:animals)).to eq([@animal1])
    end

    context "with no parameters" do
      it "assigns @animals" do
        get :find_animals_by_name, :q => "", :format => :js
        expect(assigns(:animals)).to eq({})
      end
    end

    context "with pagination" do
      it "paginates :find_animals_by_name results" do
        animal = Animal.gen :name => "paginated_animals", :shelter => current_shelter
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [animal] }

        get :find_animals_by_name, :q => "paginated_animals", :page => 1, :format => :js

        expect(assigns(:animals)).to eq([animal])
      end
    end
  end

  describe "GET print" do

    before do
      @animal = Animal.gen :shelter => current_shelter
      @note1 = Note.gen :notable => @animal, :category => "general"
      @note2 = Note.gen :notable => @animal, :category => "general", :hidden => true
    end

    it "responds successfully" do
      get :print, :id => @animal.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :print/kennel_card view" do
      get :print, :id => @animal.id
      expect(response).to render_template(:template => "animals/print/kennel_card", :layout => "app/print")
    end

    it "assigns @animal" do
      get :print, :id => @animal.id
      expect(assigns(:animal)).to eq(@animal)
    end

    it "assigns @shelter" do
      get :print, :id => @animal.id
      expect(assigns(:shelter)).to eq(current_shelter)
    end

    it "assigns @note_categories" do
      get :print, :id => @animal.id
      expect(assigns(:note_categories)).to be_empty
    end

    it "assigns @print_layout" do
      get :print, :id => @animal.id
      expect(assigns(:print_layout)).to eq("kennel_card")
    end

    it "assigns @notes" do
      get :print, :id => @animal.id, :general => "true"
      expect(assigns(:notes)).to eq([@note1])
    end

    context "with parameters" do
      it "assigns @note_categories" do
        get :print, :id => @animal.id, :general => "true", :medical => "true"
        expect(assigns(:note_categories)).to match_array(["general", "medical"])
      end

      it "assigns @notes" do
        get :print, :id => @animal.id, :general => "true", :hidden => "true"
        expect(assigns(:notes)).to match_array([@note1, @note2])
      end

      it "assigns @print_layout" do
        get :print, :id => @animal.id, :print_layout => "animal_with_notes"
        expect(assigns(:print_layout)).to eq("animal_with_notes")
      end

      it "renders the :print/animal_with_notes view" do
        get :print, :id => @animal.id, :print_layout => "animal_with_notes"
        expect(response).to render_template(:template => "animals/print/animal_with_notes", :layout => "app/print")
      end
    end
  end
end
