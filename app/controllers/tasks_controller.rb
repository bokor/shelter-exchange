class TasksController < ApplicationController
  respond_to :html, :js

  def index
    @overdue_tasks =  @current_shelter.tasks.overdue.active.includes(:taskable).all
    @today_tasks = @current_shelter.tasks.today.active.includes(:taskable).all
    @tomorrow_tasks = @current_shelter.tasks.tomorrow.active.includes(:taskable).all
    @later_tasks = @current_shelter.tasks.later.active.includes(:taskable).all

    if @overdue_tasks.blank? && @today_tasks.blank? && @tomorrow_tasks.blank? && @later_tasks.blank?
      redirect_to new_task_path
    end
  end

  def new
    @task = @current_shelter.tasks.new
    respond_with(@task)
  end

  def edit
    @task = @current_shelter.tasks.find(params[:id])
    respond_with(@task)
  end

  def create
    @taskable = find_polymorphic_class
    @task = @current_shelter.tasks.new(params[:task].merge(:taskable => @taskable))

    respond_with(@task) do |format|
      if @task.save
        flash[:notice] = "Task has been created."
        format.html { redirect_to tasks_path }
      else
        format.html { render :action => :new }
      end
    end
  end

  def update
    @task = @current_shelter.tasks.find(params[:id])
    # Added this to check if the due date changed for the view
    @task.attributes = params[:task]
    @due_date_changed = @task.due_date_changed?
    flash[:notice] = "Task has been updated." if @task.update_attributes(params[:task])
    respond_with(@task)
  end

  def destroy
    @task = @current_shelter.tasks.find(params[:id])
    flash[:notice] = "Task has been deleted." if @task.destroy
    respond_with(@task)
  end

  def complete
    @task = @current_shelter.tasks.find(params[:id])
    flash[:notice] = "Task has been completed." if @task.update_attributes({ :completed => true })
    respond_with(@task)
  end
end

