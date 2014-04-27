require "spec_helper"

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

    context "with a destroy error" do
      it "does not set a flash message" do
        allow_any_instance_of(Contact).to receive(:destroy).and_return(false)

        delete :destroy, :id => @contact.id
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "GET search" do
  # def search
  #   q = params[:q].strip.split.join("%")
  #   @contacts = if q.blank?
  #     @current_shelter.contacts.paginate(:page => params[:page]).all
  #   else
  #     @current_shelter.contacts.search(q).paginate(:page => params[:page]).all
  #   end
  # end
    before do
      @contact1 = Contact.gen :shelter => current_shelter, :first_name => "Brian", :last_name => "Bokor"
      @contact2 = Contact.gen :shelter => current_shelter, :first_name => "Claire", :last_name => "Bokor"
      @contact3 = Contact.gen :shelter => current_shelter, :first_name => "Jimmy", :last_name => "John"
    end

    it "responds successfully" do
      get :search, :q => "", :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @contacts" do
      get :search, :q => "bokor", :format => :js
      expect(assigns(:contacts)).to match_array([@contact1, @contact2])
    end

    context "with no query parameters" do
      it "assigns @contacts" do
        get :search, :q => " ", :format => :js
        expect(assigns(:contacts)).to match_array([@contact1, @contact2, @contact3])
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
end
