require "spec_helper"

describe NotesController do
  login_user

  describe "GET show" do

    before do
      @note = Note.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :show, :id => @note.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @note from id" do
      get :show, :id => @note.id, :format => :js
      expect(assigns(:note)).to eq(@note)
    end

    it "renders the :show view" do
      get :show, :id => @note.id, :format => :js
      expect(response).to render_template(:show)
    end
  end

  describe "GET edit" do

    before do
      @note = Note.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :edit, :id => @note.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @note from id" do
      get :edit, :id => @note.id, :format => :js
      expect(assigns(:note)).to eq(@note)
    end

    it "renders the :edit view" do
      get :edit, :id => @note.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "POST create" do

    before do
      note = Note.build :title => "new note", :shelter => current_shelter
      @attributes = note.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :note => @attributes, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Note" do
      expect {
        post :create, :note => @attributes, :format => :js
      }.to change(Note, :count).by(1)
    end

    it "creates a new polymorphic Note" do
      animal = Animal.gen :shelter => current_shelter
      @attributes = Note.attributes \
        :title => "Note test title",
        :notable => animal,
        :shelter => current_shelter

      expect {
        post :create, :note => @attributes, :format => :js
      }.to change(Note, :count).by(1)
    end

    it "assigns a newly created note as @note" do
      post :create, :note => @attributes, :format => :js
      expect(assigns(:note)).to be_a(Note)
      expect(assigns(:note)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :note => @attributes, :format => :js
      expect(flash[:notice]).to eq("new note has been created.")
    end

    it "renders the :create view" do
      post :create, :note => @attributes, :format => :js
      expect(response).to render_template(:create)
    end

    context "with a save error" do
      it "does not set a flash message" do
        allow_any_instance_of(Note).to receive(:save).and_return(false)

        post :create, :note => @attributes, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "PUT update" do

    before do
      @note = Note.gen :title => "new note", :shelter => current_shelter
      @update_attrs = { :title => "updated note" }
    end

    it "responds successfully" do
      put :update, :id => @note, :note => @update_attrs, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates a Note" do
      put :update, :id => @note, :note => @update_attrs, :format => :js
      expect(@note.reload.title).to eq("updated note")
    end

    it "assigns a newly updated note as @note" do
      put :update, :id => @note, :note => @update_attrs, :format => :js
      expect(assigns(:note)).to be_a(Note)
      expect(assigns(:note)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @note, :note => @update_attrs, :format => :js
      expect(flash[:notice]).to eq("updated note has been updated.")
    end

    it "renders the :update view" do
      put :update, :id => @note, :note => @update_attrs, :format => :js
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "does not set the flash message" do
        allow_any_instance_of(Note).to receive(:update_attributes).and_return(false)

        put :update, :id => @note, :note => @update_attrs, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @note = Note.gen :shelter => current_shelter
    end

    it "responds successfully" do
      delete :destroy, :id => @note.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Note" do
      expect {
        delete :destroy, :id => @note.id, :format => :js
      }.to change(Note, :count).by(-1)
    end

    it "returns deleted @note" do
      delete :destroy, :id => @note.id, :format => :js
      expect(assigns(:note)).to eq(@note)
    end

    it "renders the :delete view" do
      delete :destroy, :id => @note.id, :format => :js
      expect(response).to render_template(:destroy)
    end
  end
end

