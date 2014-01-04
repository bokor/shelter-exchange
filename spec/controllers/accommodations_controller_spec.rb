require "spec_helper"

describe AccommodationsController do
  login_user

  before do
    @accommodation = Accommodation.gen :shelter => current_shelter
  end

  describe "GET index" do

    it "responds successfully" do
      get :index, { :format => :html }
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @accommodations" do
      another_accommodation = Accommodation.gen :shelter => current_shelter

      get :index
      expect(assigns(:accommodations)).to eq([@accommodation, another_accommodation])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end

    context "without accommodations" do
      it "redirects to the :new_accommodation_path" do
        @accommodation.destroy
        get :index
        expect(response).to redirect_to(new_accommodation_path)
      end
    end
  end

  describe "GET edit" do

    it "responds successfully" do
      get :edit, :id => @accommodation.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @accommodation from id" do
      get :edit, :id => @accommodation.id, :format => :js
      expect(assigns(:accommodation)).to eq(@accommodation)
    end

    it "renders the :edit view" do
      get :edit, :id => @accommodation.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "GET new" do

    it "responds successfully" do
      get :new
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns a new accommodation as @accommodation" do
      get :new
      expect(assigns(:accommodation)).to be_a_new(Accommodation)
    end

    it "renders the :new view" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do

    before do
      accommodation = Accommodation.build :name => "Controller Crate", :shelter => current_shelter
      @attributes = accommodation.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "creates a new Accomodation" do
      expect {
        post :create, {:accommodation => @attributes}
      }.to change(Accommodation, :count).by(1)
    end

    it "assigns a newly created accommodation as @accomodation" do
      post :create, {:accommodation => @attributes}
      expect(assigns(:accommodation)).to be_a(Accommodation)
      expect(assigns(:accommodation)).to be_persisted
    end

    it "sets the flash message" do
      post :create, {:accommodation => @attributes}
      expect(flash[:notice]).to eq("Controller Crate accommodation has been created.")
    end

    it "redirects to the :accommodations_path" do
      post :create, {:accommodation => @attributes}
      expect(response).to redirect_to(accommodations_path)
    end

    context "with a save error" do
      it "renders the :new view" do
        Accommodation.any_instance.stub(:save).and_return(false)

        post :create, {:accommodation => @attributes}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT update" do

    before do
      @accommodation = Accommodation.gen :name => "Crate 1", :shelter => current_shelter
      @update_attrs = { :name => "Update Crate" }
    end

    it "updates a Accomodation" do
      expect {
        put :update, { :id => @accommodation, :accommodation => @update_attrs, :format => :js }
        @accommodation.reload
      }.to change(@accommodation, :name).to("Update Crate")
    end

    it "assigns a newly updated accommodation as @accomodation" do
      put :update, { :id => @accommodation, :accommodation => @update_attrs, :format => :js }
      expect(assigns(:accommodation)).to be_a(Accommodation)
      expect(assigns(:accommodation)).to be_persisted
    end

    it "sets the flash message" do
      put :update, { :id => @accommodation, :accommodation => @update_attrs, :format => :js }
      expect(flash[:notice]).to eq("Update Crate accommodation has been updated.")
    end

    it "renders the :edit view" do
      put :update, { :id => @accommodation, :accommodation => @update_attrs, :format => :js }
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "renders the :create view" do
        Accommodation.any_instance.stub(:save).and_return(false)

        put :update, { :id => @accommodation, :accommodation => @update_attrs, :format => :js }
        expect(response).to render_template(:update)
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @accommodation = Accommodation.gen :name => "Crate 1", :shelter => current_shelter
    end

    it "responds successfully" do
      delete :destroy, { :id => @accommodation.id, :format => :js }
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Accomodation" do
      expect {
      delete :destroy, { :id => @accommodation.id, :format => :js }
      }.to change(Accommodation, :count).by(-1)
    end

    it "sets the flash message" do
      delete :destroy, { :id => @accommodation.id, :format => :js }
      expect(flash[:notice]).to eq("Crate 1 accommodation has been deleted.")
    end

    it "returns deleted @accommodation" do
      delete :destroy, { :id => @accommodation.id, :format => :js }
      expect(assigns(:accommodation)).to eq(@accommodation)
    end

    it "renders the :delete view" do
      delete :destroy, { :id => @accommodation.id, :format => :js }
      expect(response).to render_template(:destroy)
    end
  end

  describe "GET search" do

    before do
      @accommodation = Accommodation.gen :name => "search_test", :shelter => current_shelter
    end

    it "responds successfully" do
      get :search , :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @accommodations" do
      get :search , { :q => "search", :format => :js }
      expect(assigns(:accommodations)).to eq([@accommodation])
    end

    it "assigns @accommodations" do
      get :search , { :q => "search", :format => :js }
      expect(assigns(:accommodations)).to eq([@accommodation])
    end

    context "with invalid parameters" do
      it "assigns @accommodations" do
        get :search , { :format => :js }
        expect(assigns(:accommodations)).to eq({})
      end
    end

    context "with pagination" do
      it "should paginate the results" do
        paginated_accommodation = Accommodation.gen :shelter => current_shelter
        Accommodation.should_receive(:paginate).with(:page => 1, :per_page => 25).and_return(paginated_accommodation)

        get :search, { :q => "search", :page => 1,  :format => :js }
        expect(assigns(:accommodations)).to eq([paginated_accommodation])
      end
    end
  end





end





#
#   def filter_by_type_location
#     @accommodations = @current_shelter.accommodations.filter_by_type_location(params[:animal_type_id], params[:location_id]).paginate(:page => params[:page])
#   end
# end
#