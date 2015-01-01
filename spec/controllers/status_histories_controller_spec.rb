require "rails_helper"

describe StatusHistoriesController do
  login_user

  describe "GET edit" do

    before do
      @status_history = StatusHistory.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :edit, :id => @status_history.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @status_history from id" do
      get :edit, :id => @status_history.id, :format => :js
      expect(assigns(:status_history)).to eq(@status_history)
    end

    it "renders the :edit view" do
      get :edit, :id => @status_history.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT update" do

    before do
      @status_history = StatusHistory.gen :status_date => Date.new(2014, 02, 12), :shelter => current_shelter
      @update_attrs = { :status_date => Date.new(2013, 01, 29) }
    end

    it "responds successfully" do
      put :update, :id => @status_history, :status_history => @update_attrs, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates a StatusHistory" do
      put :update, :id => @status_history, :status_history => @update_attrs, :format => :js
      expect(@status_history.reload.status_date).to eq(Date.new(2013, 01, 29))
    end

    it "assigns a newly updated status_history as @status_history" do
      put :update, :id => @status_history, :status_history => @update_attrs, :format => :js
      expect(assigns(:status_history)).to be_a(StatusHistory)
      expect(assigns(:status_history)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @status_history, :status_history => @update_attrs, :format => :js
      expect(flash[:notice]).to eq("Status history has been updated.")
    end

    it "renders the :update view" do
      put :update, :id => @status_history, :status_history => @update_attrs, :format => :js
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "does not set the flash message" do
        allow_any_instance_of(StatusHistory).to receive(:update_attributes).and_return(false)

        put :update, :id => @status_history, :status_history => @update_attrs, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end
end

