require "spec_helper"

describe DocumentsController do
  login_user

  describe "POST create" do

    before do
      document = Document.build :original_name => "testing.pdf"
      @attributes = document.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :document => @attributes, :format => :json
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Document" do
      expect {
        post :create, :document => @attributes, :format => :json
      }.to change(Document, :count).by(1)
    end

    it "creates a new polymorphic Document" do
      note = Note.gen :shelter => current_shelter

      expect {
        post :create, :document => @attributes, :note_id => note.id, :format => :json
      }.to change(Document, :count).by(1)
    end

    it "assigns @attachable" do
      note = Note.gen :shelter => current_shelter

      post :create, :document => @attributes, :note_id => note.id, :format => :json
      expect(assigns(:attachable)).to eq(note)
    end

    it "assigns @document" do
      post :create, :document => @attributes, :format => :json
      expect(assigns(:document)).to be_a(Document)
      expect(assigns(:document)).to be_persisted
    end

    context "with html format" do
      it "sets the content type" do
        post :create, :document => @attributes, :format => :html
        expect(response.header['Content-Type']).to eq("text/html; charset=utf-8")
      end

      it "renders no layout" do
        post :create, :document => @attributes, :format => :html
        expect(response).to render_template(:layout => false)
      end

      it "renders json" do
        post :create, :document => @attributes, :format => :html
        json = DocumentPresenter.new(assigns(:document)).to_uploader.to_json
        expect(response.body).to eq(json)
      end
    end

    context "with json format" do
      it "sets the content type" do
        post :create, :document => @attributes, :format => :json
        expect(response.header['Content-Type']).to eq("application/json; charset=utf-8")
      end

      it "renders json" do
        post :create, :document => @attributes, :format => :json
        json = DocumentPresenter.new(assigns(:document)).to_uploader.to_json
        expect(response.body).to eq(json)
      end
    end

    context "with a save error" do
      it "renders error json" do
        allow_any_instance_of(Document).to receive(:save).and_return(false)

        post :create, :document => @attributes, :format => :json
        expect(MultiJson.load(response.body)).to match_array([
          { "error" => "" }
        ])
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @document = Document.gen
    end

    it "responds successfully" do
      delete :destroy, :id => @document.id, :format => :json
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Document" do
      expect {
        delete :destroy, :id => @document.id, :format => :json
      }.to change(Document, :count).by(-1)
    end

    it "assigns @document" do
      delete :destroy, :id => @document.id, :format => :json
      expect(assigns(:document)).to eq(@document)
    end

    it "renders json" do
      delete :destroy, :id => @document.id, :format => :json
      expect(response.body).to be_true
    end
  end
end

