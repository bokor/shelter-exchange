require "rails_helper"

describe ContactsController do
  login_user

  describe "GET index" do

    before do
      @contact = Contact.gen :shelter => current_shelter
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

    it "assigns @total_contacts" do
      Contact.gen :shelter => current_shelter

      get :index
      expect(assigns(:total_contacts)).to eq(2)
    end

    it "assigns @contacts" do
      another_contact = Contact.gen :shelter => current_shelter

      get :index
      expect(assigns(:contacts)).to match_array([@contact, another_contact])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end

    context "with pagination" do
      it "paginates :index results" do
        contact = Contact.gen
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [contact] }

        get :index, :page => 1, :format => :js

        expect(assigns(:contacts)).to eq([contact])
      end
    end
  end

  describe "GET show" do

    before do
      @contact = Contact.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :show, :id => @contact.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "responds successfully with js format" do
      get :show, :id => @contact.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @contact" do
      get :show, :id => @contact.id
      expect(assigns(:contact)).to eq(@contact)
    end

    it "assigns @contact" do
      note1 = Note.gen :notable => @contact
      note2 = Note.gen :notable => @contact

      get :show, :id => @contact.id
      expect(assigns(:notes)).to match_array([note1, note2])
    end

    it "renders the :show view" do
      get :show, :id => @contact.id
      expect(response).to render_template(:show)
    end

    context "with a record not found error" do
      it "set a flash message" do
        get :show, :id => "123abc"
        expect(flash[:error]).to eq("You have requested an invalid contact!")
      end

      it "redirects to the :contacts_path" do
        get :show, :id => "123abc"
        expect(response).to redirect_to(contacts_path)
      end
    end

    context "with pagination" do
      it "paginates :index results" do
        animal = Animal.gen
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [animal] }

        get :show, :id => @contact.id, :page => 1, :format => :js

        expect(assigns(:animals)).to eq([animal])
      end
    end
  end

  describe "GET edit" do

    before do
      @contact = Contact.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :edit, :id => @contact.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @contact" do
      get :edit, :id => @contact.id
      expect(assigns(:contact)).to eq(@contact)
    end

    it "renders the :edit view" do
      get :edit, :id => @contact.id
      expect(response).to render_template(:edit)
    end
  end

  describe "GET new" do

    it "responds successfully" do
      get :new
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns a new contact as @contact" do
      get :new
      expect(assigns(:contact)).to be_a_new(Contact)
    end

    it "renders the :new view" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do

    before do
      contact = Contact.build :shelter => current_shelter, :first_name => "Joe", :last_name => "Smith"
      @attributes = contact.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "creates a new Contact" do
      expect {
        post :create, :contact => @attributes
      }.to change(Contact, :count).by(1)
    end

    it "assigns a newly created contact as @contact" do
      post :create, :contact => @attributes
      expect(assigns(:contact)).to be_a(Contact)
      expect(assigns(:contact)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :contact => @attributes
      expect(flash[:notice]).to eq("Joe Smith has been created.")
    end

    it "redirects to the :contact_path" do
      post :create, :contact => @attributes
      expect(response).to redirect_to(contact_path(assigns(:contact)))
    end

    context "with a save error" do
      it "does not set a flash message" do
        allow_any_instance_of(Contact).to receive(:save).and_return(false)

        post :create, :contact => @attributes
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "PUT update" do

    before do
      @contact = Contact.gen :shelter => current_shelter, :first_name => "Joe", :last_name => "Smith"
      @update_attrs = { :first_name => "Jane" }
    end

    it "updates a Contact" do
      expect {
        put :update, :id => @contact.id, :contact => @update_attrs
        @contact.reload
      }.to change(@contact, :name).to("Jane Smith")
    end

    it "assigns a newly updated contact as @accomodation" do
      put :update, :id => @contact.id, :contact => @update_attrs
      expect(assigns(:contact)).to be_a(Contact)
      expect(assigns(:contact)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @contact.id, :contact => @update_attrs
      expect(flash[:notice]).to eq("Jane Smith has been updated.")
    end

    it "redirects to the :contact_path" do
      put :update, :id => @contact.id, :contact => @update_attrs
      expect(response).to redirect_to(contact_path(assigns(:contact)))
    end

    context "with a update attributes error" do
      it "does not set a flash message" do
        allow_any_instance_of(Contact).to receive(:update_attributes).and_return(false)

        put :update, :id => @contact.id
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @contact = Contact.gen :shelter => current_shelter, :first_name => "Joe", :last_name => "Smith"
    end

    it "deletes an Contact" do
      expect {
        delete :destroy, :id => @contact.id
      }.to change(Contact, :count).by(-1)
    end

    it "sets the flash message" do
      delete :destroy, :id => @contact.id
      expect(flash[:notice]).to eq("Joe Smith has been deleted.")
    end

    it "returns deleted @contact" do
      delete :destroy, :id => @contact.id
      expect(assigns(:contact)).to eq(@contact)
    end

    it "redirects to the :contact_path" do
      delete :destroy, :id => @contact.id
      expect(response).to redirect_to(contacts_path)
    end

    it "renders the :destroy view" do
      delete :destroy, :id => @contact.id, :format => :js
      expect(response).to render_template(:destroy)
    end

    context "with a destroy error" do
      it "does not set a flash message" do
        allow_any_instance_of(Contact).to receive(:destroy).and_return(false)

        delete :destroy, :id => @contact.id
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "GET search" do

    before do
      @contact1 = Contact.gen :shelter => current_shelter, :first_name => "Brian", :last_name => "Bokor"
      @contact2 = Contact.gen :shelter => current_shelter, :first_name => "Claire", :last_name => "Bokor"
      @contact3 = Contact.gen :shelter => current_shelter, :first_name => "Jimmy", :last_name => "John"
      @contact4 = Contact.gen :shelter => current_shelter, :company_name => "Bokor, Inc."
    end

    it "responds successfully" do
      get :search, :q => "", :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @contacts" do
      get :search, :q => "bokor", :format => :js
      expect(assigns(:contacts)).to match_array([@contact1, @contact2, @contact4])
    end

    it "renders the :search view" do
      get :search, :q => "bokor", :format => :js
      expect(response).to render_template(:search)
    end

    context "with no query parameters" do
      it "assigns @contacts" do
        get :search, :q => " ", :format => :js
        expect(assigns(:contacts)).to match_array([@contact1, @contact2, @contact3, @contact4])
      end
    end

    context "with pagination" do
      it "paginates :search results" do
        contact = Contact.gen :shelter => current_shelter, :first_name => "paginated", :last_name => "contact"
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [contact] }

        get :search, :q => "paginated contact", :page => 1, :format => :js
        expect(assigns(:contacts)).to match_array([contact])
      end
    end
  end

  describe "GET filter_by_last_name_role" do

    before do
      @contact1 = Contact.gen :last_name => "A1", :adopter => "1", :foster => "0", :shelter => current_shelter
      @contact2 = Contact.gen :last_name => "B1", :adopter => "1", :foster => "0", :shelter => current_shelter
    end

    it "responds successfully" do
      get :filter_by_last_name_role, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :filter_by_last_name_role view" do
      get :filter_by_last_name_role, :format => :js
      expect(response).to render_template(:filter_by_last_name_role)
    end

    it "assigns @contacts" do
      get :filter_by_last_name_role, :by_last_name => "A", :by_role => "adopter", :format => :js
      expect(assigns(:contacts)).to match_array([@contact1])
    end

    context "with no parameters" do
      it "assigns @contacts" do
        get :filter_by_last_name_role, :format => :js
        expect(assigns(:contacts)).to match_array([@contact1, @contact2])
      end
    end

    context "with pagination" do
      it "paginates :filter_by_last_initial_category results" do
        contact = Contact.gen
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [contact] }

        get :filter_by_last_name_role, :page => 1, :format => :js
        expect(assigns(:contacts)).to eq([contact])
      end
    end
  end

  describe "GET filter_animals_by_status" do

    before do
      @contact = Contact.gen :last_name => "A1", :adopter => "1", :foster => "0", :shelter => current_shelter

      @animal1 = Animal.gen :shelter => current_shelter
      @animal2 = Animal.gen :shelter => current_shelter

      StatusHistory.gen :contact => @contact, :animal => @animal1, :animal_status_id => @animal1.animal_status_id
      StatusHistory.gen :contact => @contact, :animal => @animal2, :animal_status_id => @animal2.animal_status_id
    end

    it "responds successfully" do
      get :filter_animals_by_status, :id => @contact.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :filter_animals_by_status view" do
      get :filter_animals_by_status, :id => @contact.id, :format => :js
      expect(response).to render_template(:filter_animals_by_status)
    end

    it "assigns @animals" do
      get :filter_animals_by_status, :id => @contact.id, :by_status => @animal1.animal_status_id, :format => :js
      expect(assigns(:animals)).to match_array([@animal1])
    end

    context "with no parameters" do
      it "assigns @animals" do
        get :filter_animals_by_status, :id => @contact.id, :by_status => "", :format => :js
        expect(assigns(:animals)).to match_array([@animal1, @animal2])
      end
    end

    context "with pagination" do

      it "paginates :filter_animals_by_status results with all" do
        animal = Animal.gen
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [animal] }

        get :filter_animals_by_status, :id => @contact.id, :by_status => "", :page => 1, :format => :js
        expect(assigns(:animals)).to eq([animal])
      end

      it "paginates :filter_animals_by_status results with status" do
        animal = Animal.gen
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [animal] }

        get :filter_animals_by_status, :id => @contact.id, :by_status => 1, :page => 1, :format => :js
        expect(assigns(:animals)).to eq([animal])
      end
    end
  end

  describe "GET find_by_full_name" do

    before do
      @contact1 = Contact.gen :first_name => "jim", :last_name => "smith", :shelter => current_shelter
      @contact2 = Contact.gen :first_name => "jimmy", :last_name => "smithy", :shelter => current_shelter
      @contact3 = Contact.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :find_by_full_name, :q => "", :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the :find_by_full_name view" do
      get :find_by_full_name, :q => "", :format => :js
      expect(response).to render_template(:find_by_full_name)
    end

    it "assigns @contacts" do
      get :find_by_full_name, :q => "jim smith", :format => :js
      expect(assigns(:contacts)).to match_array([@contact1, @contact2])
    end

    context "with no parameters" do
      it "assigns @contacts" do
        get :find_by_full_name, :q => "", :format => :js
        expect(assigns(:contacts)).to match_array([@contact1, @contact2, @contact3])
      end
    end

    context "with pagination" do
      it "paginates :find_by_full_name results" do
        contact = Contact.gen :first_name => "billy", :shelter => current_shelter
        allow(WillPaginate::Collection).to receive(:create).with(1, 25) { [contact] }

        get :find_by_full_name, :q => "billy", :page => 1, :format => :js

        expect(assigns(:contacts)).to eq([contact])
      end
    end
  end

  describe "POST export" do

    before do
      @contact1 = Contact.gen :shelter => current_shelter, :adopter => true
      @contact2 = Contact.gen :shelter => current_shelter, :adopter => true, :staff => true
      @contact3 = Contact.gen :shelter => current_shelter
    end

    it "responds successfully" do
      post :export, :contact => { :by_role => "" }, :format => :csv
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    context "with no params" do

      it "sends csv file" do
        csv_string = CSV.generate{|csv| Contact::ExportPresenter.as_csv([@contact1, @contact2, @contact3], csv) }

        expect(controller).to receive(:send_data).
          with(csv_string, :filename => "contacts.csv") { controller.render :nothing => true }

        post :export, :contact => { :by_role => "" }, :format => :csv
      end
    end

    context "with role filters" do

      it "sends csv file" do
        csv_string = CSV.generate{|csv| Contact::ExportPresenter.as_csv([@contact1, @contact2], csv) }

        expect(controller).to receive(:send_data).
          with(csv_string, :filename => "contacts.csv") { controller.render :nothing => true }

        post :export, :contact => { :by_role => "adopter" }, :format => :csv
      end
    end
  end

  describe "POST import" do

    before do
      path = Rails.root.join("spec", "data", "documents", "contacts.csv")
      @contacts_csv = Rack::Test::UploadedFile.new(path)
    end

    after do
      # Delete all files in tmp dir
      path = File.join(Rails.root, "tmp", "contacts", "import", "*")
      FileUtils.rm_rf(Dir.glob(path))
    end

    it "responds successfully" do
      post :import, :contact => { :file => @contacts_csv }
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @headers" do
      post :import, :contact => { :file => @contacts_csv }
      expect(assigns(:headers)).to eq([
        "First Name",
        "Last Name",
        "Job Title",
        "Company Name",
        "E-mail Address",
        "Home Phone",
        "Mobile Phone",
        "Home Street",
        "Home Street 2",
        "Home City",
        "Home State",
        "Home Postal Code",
        "Home Country"
      ])
    end

    it "assigns @no_headers_warning" do
      post :import, :contact => { :file => @contacts_csv }
      expect(assigns(:no_headers_warning)).to be_falsey
    end

    it "assigns @csv_filepath" do
      csv_filepath = Rails.root.join("tmp", "contacts", "import", "#{current_shelter.id}-#{current_user.id}-contacts.csv")
      post :import, :contact => { :file => @contacts_csv }
      expect(assigns(:csv_filepath)).to eq(csv_filepath.to_path)
    end

    it "saves a local temp file" do
      csv_filepath = Rails.root.join("tmp", "contacts", "import", "#{current_shelter.id}-#{current_user.id}-contacts.csv")
      post :import, :contact => { :file => @contacts_csv }
      expect(File).to exist(csv_filepath)
    end

    it "renders the :import view" do
      post :import, :contact => { :file => @contacts_csv }
      expect(response).to render_template(:import)
    end

    context "without an attached file" do
      it "set a flash message" do
        post :import
        expect(flash[:error]).to eq("When importing contacts, Please select a CSV file before clicking 'Upload CSV'.")
      end

      it "redirects to the :contacts_path" do
        post :import
        expect(response).to redirect_to(contacts_path)
      end
    end

    context "without csv headers" do
      it "assigns @no_headers_warning" do
        path = Rails.root.join("spec", "data", "documents", "contacts_without_headers.csv")
        post :import, :contact => { :file => Rack::Test::UploadedFile.new(path) }
        expect(assigns(:no_headers_warning)).to be_truthy
      end
    end
  end

  describe "POST import_mapping" do

    before do
      # Upload File to tmp directory location
      @csv_filepath = File.join(Rails.root, "tmp", "contacts", "import", "#{current_shelter.id}-#{current_user.id}-contacts.csv")
      uploaded_file_path = File.join(Rails.root, "spec", "data", "documents", "contacts.csv")
      file_reader = open(uploaded_file_path).read
      File.open(@csv_filepath, "wb") { |f| f.write(file_reader) }

      @attributes = {
        :csv_filepath => @csv_filepath,
        :first_name_mapping => "First Name",
        :last_name_mapping => "Last Name",
        :job_title_mapping => "Job Title",
        :company_name_mapping => "Company Name",
        :street_mapping => "Home Street",
        :street_2_mapping => "Home Street 2",
        :city_mapping => "Home City",
        :state_mapping => "Home State",
        :zip_code_mapping => "Home Postal Code",
        :email_mapping  => "E-mail Address",
        :phone_mapping => "Home Phone",
        :mobile_mapping => "Mobile Phone"
      }
    end

    after do
      # Delete all files in tmp dir
      path = File.join(Rails.root, "tmp", "contacts", "import", "*")
      FileUtils.rm_rf(Dir.glob(path))
    end

    it "responds successfully" do
      post :import_mapping, :contact => @attributes
      expect(response.status).to eq(302)
    end

    it "creates a new Contact" do
      expect {
        post :import_mapping, :contact => @attributes
      }.to change(Contact, :count).by(2)
    end

    it "maps contact data" do
      post :import_mapping, :contact => @attributes
      contact = Contact.first
      expect(contact.first_name).to eq("Brian")
      expect(contact.last_name).to eq("Bokor")
      expect(contact.job_title).to eq("cto")
      expect(contact.company_name).to eq("Shelter Exchange Inc")
      expect(contact.street).to eq("123 main st")
      expect(contact.street_2).to be_nil
      expect(contact.city).to eq("Redwood City")
      expect(contact.state).to eq("CA")
      expect(contact.zip_code).to eq("94063")
      expect(contact.phone).to eq("6509999999")
      expect(contact.mobile).to eq("6509999999")
      expect(contact.email).to eq("bb_test@example.com")
    end

    it "deletes the local temp file" do
      csv_filepath = Rails.root.join("tmp", "contacts", "import", "#{current_shelter.id}-#{current_user.id}-contacts.csv")
      post :import_mapping, :contact => @attributes
      expect(File).to_not exist(csv_filepath)
    end

    it "set a flash message" do
      post :import_mapping, :contact => @attributes
      expect(flash[:notice]).to eq("Imported 2 contacts.")
    end

    it "redirects to the :contacts_path" do
      post :import_mapping, :contact => @attributes
      expect(response).to redirect_to(contacts_path)
    end

    context "with no mappings" do

      before do
        @attributes = {
          :csv_filepath => @csv_filepath,
          :first_name_mapping => "",
          :last_name_mapping => "",
          :job_title_mapping => "",
          :company_name_mapping => "",
          :street_mapping => "",
          :street_2_mapping => "",
          :city_mapping => "",
          :state_mapping => "",
          :zip_code_mapping => "",
          :email_mapping  => "",
          :phone_mapping => "",
          :mobile_mapping => ""
        }
      end

      it "does not create contacts" do
        expect{
          post :import_mapping, :contact => @attributes
        }.to_not change(Contact, :count)
      end

      it "set a flash message" do
        post :import_mapping, :contact => @attributes
        expect(flash[:notice]).to eq("Imported 0 contacts.")
      end
    end
  end
end

