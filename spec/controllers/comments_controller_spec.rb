require "rails_helper"

describe CommentsController do
  login_user

  describe "GET index" do

    before do
      @status_history = StatusHistory.gen
      @comment = Comment.gen :shelter => current_shelter, :commentable => @status_history
    end

    it "responds successfully" do
      get :index, :status_history_id => @status_history.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @comments" do
      another_comment = Comment.gen :shelter => current_shelter, :commentable => @status_history

      get :index, :status_history_id => @status_history.id, :format => :js
      expect(assigns(:comments)).to eq([@comment, another_comment])
    end

    it "renders the :index view" do
      get :index, :status_history_id => @status_history.id, :format => :js
      expect(response).to render_template(:index)
    end
  end

  describe "GET edit" do

    before do
      @comment = Comment.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :edit, :id => @comment.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @comment from id" do
      get :edit, :id => @comment.id, :format => :js
      expect(assigns(:comment)).to eq(@comment)
    end

    it "renders the :edit view" do
      get :edit, :id => @comment.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "POST create" do

    before do
      animal = Animal.gen :shelter => current_shelter
      comment = Comment.build \
        :comment => "Comment test",
        :commentable => animal,
        :shelter => current_shelter
      @attributes = comment.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :comment => @attributes, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Comment" do
      expect {
        post :create, :comment => @attributes, :format => :js
      }.to change(Comment, :count).by(1)
    end

    it "creates a new Comment with commentable type and id" do
      animal = Animal.gen :shelter => current_shelter
      comment = Comment.build :comment => "Comment test", :shelter => current_shelter
      @attributes = comment.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
      @attributes.merge!(:commentable_type => "Animal", :commentable_id => animal.id)

      expect {
        post :create, :comment => @attributes, :format => :js
      }.to change(Comment, :count).by(1)

      expect(Comment.last.commentable).to eq(animal)
    end

    it "assigns a newly created comment as @comment" do
      post :create, :comment => @attributes, :format => :js
      expect(assigns(:comment)).to be_a(Comment)
      expect(assigns(:comment)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :comment => @attributes, :format => :js
      expect(flash[:notice]).to eq("Comment test has been created.")
    end

    it "renders the :create view" do
      post :create, :comment => @attributes, :format => :js
        expect(response).to render_template(:create)
    end

    context "with a save error" do
      it "renders the :create view" do
        allow_any_instance_of(Comment).to receive(:save).and_return(false)

        post :create, :comment => @attributes, :format => :js
        expect(response).to render_template(:create)
      end
    end
  end

  describe "PUT update" do

    before do
      @comment = Comment.gen :comment => "Comment comment", :shelter => current_shelter
      @update_attrs = { :comment => "Comment is a new one" }
    end

    it "responds successfully" do
      put :update, :id => @comment, :comment => @update_attrs, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates a Comment" do
      put :update, :id => @comment, :comment => @update_attrs, :format => :js
      expect(@comment.reload.comment).to eq("Comment is a new one")
    end

    it "assigns a newly updated comment as @comment" do
      put :update, :id => @comment, :comment => @update_attrs, :format => :js
      expect(assigns(:comment)).to be_a(Comment)
      expect(assigns(:comment)).to be_persisted
    end

    it "sets the flash message" do
      put :update, :id => @comment, :comment => @update_attrs, :format => :js
      expect(flash[:notice]).to eq("Comment is a new one has been updated.")
    end

    it "renders the :edit view" do
      put :update, :id => @comment, :comment => @update_attrs, :format => :js
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "renders the :edit view" do
        allow_any_instance_of(Comment).to receive(:save).and_return(false)

        put :update, :id => @comment, :comment => @update_attrs, :format => :js
        expect(response).to render_template(:update)
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @comment = Comment.gen :comment => "Comment 1", :shelter => current_shelter
    end

    it "responds successfully" do
      delete :destroy, :id => @comment.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Comment" do
      expect {
        delete :destroy, :id => @comment.id, :format => :js
      }.to change(Comment, :count).by(-1)
    end

    it "returns deleted @comment" do
      delete :destroy, :id => @comment.id, :format => :js
      expect(assigns(:comment)).to eq(@comment)
    end

    it "renders the :delete view" do
      delete :destroy, :id => @comment.id, :format => :js
      expect(response).to render_template(:destroy)
    end

    context "with a destroy error" do
      it "does not set a flash message" do
        allow_any_instance_of(Comment).to receive(:destroy).and_return(false)

        delete :destroy, :id => @comment.id, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end
end

