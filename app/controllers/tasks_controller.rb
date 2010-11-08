class TasksController < ApplicationController
  respond_to :html, :js
  
  def index
    # @tasks = Task.for_global.all
    @overdue_tasks = Task.overdue.all
    @today_tasks = Task.today.all
    @tomorrow_tasks = Task.tomorrow.all
    @later_tasks = Task.later.all

    if @overdue_tasks.blank? and @today_tasks.blank? and @tomorrow_tasks.blank? and @later_tasks.blank?
      @task = Task.new
      respond_with(@task)
    else
      @task_validate = true
    end  
  end
  
  def show
    redirect_to tasks_path and return
  end
  
  def edit
    begin
      @task = Task.find(params[:id])
      respond_with(@task)
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid task => #{params[:id]}")
      flash[:error] = "You have requested an invalid task!"
      redirect_to tasks_path and return
    end
  end
  
  def new
    @task = Task.new
    respond_with(@task)
  end
  
  def create
    @taskable = find_polymorphic_class
    @task = Task.new(params[:task].merge(:taskable => @taskable))

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
    @task = Task.find(params[:id])   
    respond_with(@task) do |format|
      if @task.update_attributes(params[:task])  
        flash[:notice] = "Task has been updated."
        format.html { redirect_to tasks_path }
      else
        format.html { render :action => :edit }
      end
    end
  end
  
  def destroy
     @task = Task.find(params[:id])
     @task.destroy
     flash[:error] = "Task has been deleted."
     respond_with(@task)
  end


end
