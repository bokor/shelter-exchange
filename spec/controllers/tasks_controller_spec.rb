require "rails_helper"

describe TasksController do
  login_user

  describe "GET index" do

    before do
      @overdue_task = Task.gen :due_date => Date.today - 2, :due_category => "today", :shelter => current_shelter
      @today_task = Task.gen :due_date => Date.today, :due_category => "today", :shelter => current_shelter
      @tomorrow_task = Task.gen :due_date => Date.today + 1, :due_category => "tomorrow", :shelter => current_shelter
      @later_task = Task.gen :due_date => Date.today + 2, :due_category => "later", :shelter => current_shelter
    end

    it "responds successfully" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @overdue_tasks" do
      get :index
      expect(assigns(:overdue_tasks)).to eq([@overdue_task])
    end

    it "assigns @today_tasks" do
      get :index
      expect(assigns(:today_tasks)).to eq([@today_task])
    end

    it "assigns @tomorrow_tasks" do
      get :index
      expect(assigns(:tomorrow_tasks)).to eq([@tomorrow_task])
    end

    it "assigns @later_tasks" do
      get :index
      expect(assigns(:later_tasks)).to eq([@later_task])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end

    context "without tasks" do
      it "redirects to the :new_task_path" do
        @overdue_task.destroy
        @today_task.destroy
        @tomorrow_task.destroy
        @later_task.destroy

        get :index
        expect(response).to redirect_to(new_task_path)
      end
    end
  end

  describe "GET edit" do

    before do
      @task = Task.gen :shelter => current_shelter
    end

    it "responds successfully" do
      get :edit, :id => @task.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @task from id" do
      get :edit, :id => @task.id, :format => :js
      expect(assigns(:task)).to eq(@task)
    end

    it "renders the :edit view" do
      get :edit, :id => @task.id, :format => :js
      expect(response).to render_template(:edit)
    end
  end

  describe "GET new" do

    it "responds successfully" do
      get :new
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns a new task as @task" do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
    end

    it "renders the :new view" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do

    before do
      task = Task.build :details => "Task details", :shelter => current_shelter
      @attributes = task.attributes.symbolize_keys.except(:created_at, :updated_at, :id)
    end

    it "responds successfully" do
      post :create, :task => @attributes, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "creates a new Task" do
      expect {
        post :create, :task => @attributes
      }.to change(Task, :count).by(1)
    end

    it "creates a new polymorphic Task" do
      animal = Animal.gen :shelter => current_shelter
      task = Task.build \
        :details => "Task details",
        :taskable => animal,
        :shelter => current_shelter
      @attributes = task.attributes.symbolize_keys.except(:created_at, :updated_at, :id)

      expect {
        post :create, :task => @attributes
      }.to change(Task, :count).by(1)
    end

    it "assigns a newly created task as @task" do
      post :create, :task => @attributes
      expect(assigns(:task)).to be_a(Task)
      expect(assigns(:task)).to be_persisted
    end

    it "sets the flash message" do
      post :create, :task => @attributes
      expect(flash[:notice]).to eq("Task has been created.")
    end

    it "redirects to the :tasks_path" do
      post :create, :task => @attributes
      expect(response).to redirect_to(tasks_path)
    end

    context "with js format" do
      it "renders the :create view" do
        post :create, :task => @attributes, :format => :js
        expect(response).to render_template(:create)
      end
    end

    context "with a save error" do
      it "renders the :new view" do
        allow_any_instance_of(Task).to receive(:save).and_return(false)

        post :create, :task => @attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT update" do

    before do
      @task = Task.gen :details => "Task details", :shelter => current_shelter
      @update_attrs = { :details => "Update Task details" }
    end

    it "responds successfully" do
      put :update, :id => @task, :task => @update_attrs, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates a Task" do
      put :update, :id => @task, :task => @update_attrs, :format => :js
      expect(@task.reload.details).to eq("Update Task details")
    end

    it "assigns a newly updated task as @task" do
      put :update, :id => @task, :task => @update_attrs, :format => :js
      expect(assigns(:task)).to be_a(Task)
      expect(assigns(:task)).to be_persisted
    end

    it "assigned due_date_changed" do
      task_attributes = @update_attrs.merge!(:due_date => Date.today - 1.month)

      put :update, :id => @task, :task => task_attributes, :format => :js
      expect(assigns(:due_date_changed)).to be_truthy
    end

    it "sets the flash message" do
      put :update, :id => @task, :task => @update_attrs, :format => :js
      expect(flash[:notice]).to eq("Task has been updated.")
    end

    it "renders the :update view" do
      put :update, :id => @task, :task => @update_attrs, :format => :js
      expect(response).to render_template(:update)
    end

    context "with a save error" do
      it "does not set the flash message" do
        allow_any_instance_of(Task).to receive(:update_attributes).and_return(false)

        put :update, :id => @task, :task => @update_attrs, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "DELETE destroy" do

    before do
      @task = Task.gen :shelter => current_shelter
    end

    it "responds successfully" do
      delete :destroy, :id => @task.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "deletes an Task" do
      expect {
        delete :destroy, :id => @task.id, :format => :js
      }.to change(Task, :count).by(-1)
    end

    it "sets the flash message" do
      delete :destroy, :id => @task.id, :format => :js
      expect(flash[:notice]).to eq("Task has been deleted.")
    end

    it "returns deleted @task" do
      delete :destroy, :id => @task.id, :format => :js
      expect(assigns(:task)).to eq(@task)
    end

    it "renders the :delete view" do
      delete :destroy, :id => @task.id, :format => :js
      expect(response).to render_template(:destroy)
    end

    context "with a destroy error" do
      it "does not set a flash message" do
        allow_any_instance_of(Task).to receive(:destroy).and_return(false)

        delete :destroy, :id => @task.id, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe "POST complete" do

    before do
      @task = Task.gen :shelter => current_shelter
    end

    it "responds successfully" do
      post :complete, :id => @task.id, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "completes an task" do
      expect(@task.completed).to be_falsey

      expect {
        post :complete, :id => @task.id, :format => :js
      }.to change(Task, :count).by(0)

      expect(@task.reload.completed).to be_truthy
    end

    it "sets the flash message" do
      post :complete, :id => @task.id, :format => :js
      expect(flash[:notice]).to eq("Task has been completed.")
    end

    context "with a update error" do
      it "does not set a flash message" do
        allow_any_instance_of(Task).to receive(:update_attributes).and_return(false)

        post :complete, :id => @task.id, :format => :js
        expect(flash[:notice]).to be_nil
      end
    end
  end
end

