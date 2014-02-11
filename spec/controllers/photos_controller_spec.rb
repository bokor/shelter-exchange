require "spec_helper"

describe PhotosController do
  login_user

  describe "POST create" do

    before do
      photo = Photo.build
      @attributes = photo.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :photo => @attributes, :format => :json
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Photo" do
      expect {
        post :create, :photo => @attributes, :format => :json
      }.to change(Photo, :count).by(1)
    end

    it "creates a new polymorphic Photo" do
      animal = Animal.gen :shelter => current_shelter

      expect {
        post :create, :photo => @attributes, :animal_id => animal.id, :format => :json
      }.to change(Photo, :count).by(1)
    end

    it "assigns @attachable" do
      animal = Animal.gen :shelter => current_shelter

      post :create, :photo => @attributes, :animal_id => animal.id, :format => :json
      expect(assigns(:attachable)).to eq(animal)
    end

    it "assigns @photo" do
      post :create, :photo => @attributes, :format => :json
      expect(assigns(:photo)).to be_a(Photo)
      expect(assigns(:photo)).to be_persisted
    end

    context "with html format" do
      it "sets the content type" do
        post :create, :photo => @attributes, :format => :html
        expect(response.header['Content-Type']).to eq("text/html; charset=utf-8")
      end

      it "renders no layout" do
        post :create, :photo => @attributes, :format => :html
        expect(response).to render_template(:layout => false)
      end

      it "renders json" do
        post :create, :photo => @attributes, :format => :html
        json = PhotoPresenter.new(assigns(:photo)).to_uploader.to_json
        expect(response.body).to eq(json)
      end
    end

    context "with json format" do
      it "sets the content type" do
        post :create, :photo => @attributes, :format => :json
        expect(response.header['Content-Type']).to eq("application/json; charset=utf-8")
      end

      it "renders json" do
        post :create, :photo => @attributes, :format => :json
        json = PhotoPresenter.new(assigns(:photo)).to_uploader.to_json
        expect(response.body).to eq(json)
      end
    end

    context "with a save error" do
      it "renders error json" do
        allow_any_instance_of(Photo).to receive(:save).and_return(false)

        post :create, :photo => @attributes, :format => :json
        expect(MultiJson.load(response.body)).to match_array([
          { "error" => "" }
        ])
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @photo = Photo.gen
    end

    it "responds successfully" do
      delete :destroy, :id => @photo.id, :format => :json
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Photo" do
      expect {
        delete :destroy, :id => @photo.id, :format => :json
      }.to change(Photo, :count).by(-1)
    end

    it "assigns @photo" do
      delete :destroy, :id => @photo.id, :format => :json
      expect(assigns(:photo)).to eq(@photo)
    end

    it "renders json" do
      delete :destroy, :id => @photo.id, :format => :json
      expect(response.body).to be_true
    end
  end

  describe "GET refresh_gallery" do
  # def refresh_gallery
  #   @attachable = find_polymorphic_class
  #   @photos = @attachable.photos
  #   respond_to do |format|
  #     format.json { render :json => @gallery_photos = PhotoPresenter.as_gallery_collection(@photos) }
  #   end
  # end
    before do
      @animal = Animal.gen :shelter => current_shelter
      @photo1 = Photo.gen :attachable => @animal
      @photo2 = Photo.gen :attachable => @animal
    end

    it "responds successfully" do
      get :refresh_gallery, :animal_id => @animal.id, :format => :json
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @attachable" do
      get :refresh_gallery, :animal_id => @animal.id, :format => :json
      expect(assigns(:attachable)).to eq(@animal)
    end

    it "assigns @photos" do
      get :refresh_gallery, :animal_id => @animal.id, :format => :json
      expect(assigns(:photos)).to match_array([@photo1, @photo2])
    end

    it "assigns @gallery_photos" do
      get :refresh_gallery, :animal_id => @animal.id, :format => :json
      expect(assigns(:gallery_photos)).to eq(PhotoPresenter.as_gallery_collection(assigns(:photos)))
    end

    it "renders json" do
      get :refresh_gallery, :animal_id => @animal.id, :format => :json
      expect(response.body).to eq(assigns(:gallery_photos))
    end
  end
end

