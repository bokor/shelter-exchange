require "rails_helper"

describe TransfersController do
  login_user

  describe "GET edit" do

    before do
      @transfer = Transfer.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :edit, :id => @transfer.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @transfer from id" do
      get :edit, :id => @transfer.id, :format => :js
      expect(assigns(:transfer)).to eq(@transfer)
    end

    it "renders the :edit view" do
      get :edit, :id => @transfer.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "POST create" do

    before do
      transfer = Transfer.build :shelter => current_shelter
      @attributes = transfer.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :transfer => @attributes, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Transfer" do
      expect {
        post :create, :transfer => @attributes, :format => :js
      }.to change(Transfer, :count).by(1)
    end

    it "assigns a newly created transfer as @transfer" do
      post :create, :transfer => @attributes, :format => :js
      expect(assigns(:transfer)).to be_a(Transfer)
      expect(assigns(:transfer)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :transfer => @attributes, :format => :js
      expect(flash[:notice]).to eq("Transfer has been created.")
    end

    it "renders the :create view" do
      post :create, :transfer => @attributes, :format => :js
      expect(response).to render_template(:create)
    end

    context "with a save error" do
      it "does not set a flash message" do
        allow_any_instance_of(Transfer).to receive(:save).and_return(false)

        post :create, :transfer => @attributes, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "PUT update" do

    before do
      @transfer = Transfer.gen :status => "approved", :shelter => current_shelter
      @update_attrs = { :status => "completed" }
    end

    it "responds successfully" do
      put :update, :id => @transfer, :transfer => @update_attrs, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates a Transfer" do
      put :update, :id => @transfer, :transfer => @update_attrs, :format => :js
      expect(@transfer.reload.status).to eq("completed")
    end

    it "assigns a newly updated transfer as @transfer" do
      put :update, :id => @transfer, :transfer => @update_attrs, :format => :js
      expect(assigns(:transfer)).to be_a(Transfer)
      expect(assigns(:transfer)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @transfer, :transfer => @update_attrs, :format => :js
      expect(flash[:notice]).to eq("Transfer has been completed.")
    end

    it "renders the :update view" do
      put :update, :id => @transfer, :transfer => @update_attrs, :format => :js
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "does not set the flash message" do
        allow_any_instance_of(Transfer).to receive(:update_attributes).and_return(false)

        put :update, :id => @transfer, :transfer => @update_attrs, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @transfer = Transfer.gen :shelter => current_shelter
    end

    it "responds successfully" do
      delete :destroy, :id => @transfer.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Transfer" do
      expect {
        delete :destroy, :id => @transfer.id, :format => :js
      }.to change(Transfer, :count).by(-1)
    end

    it "returns deleted @transfer" do
      delete :destroy, :id => @transfer.id, :format => :js
      expect(assigns(:transfer)).to eq(@transfer)
    end

    it "renders the :delete view" do
      delete :destroy, :id => @transfer.id, :format => :js
      expect(response).to render_template(:destroy)
    end
  end
end

