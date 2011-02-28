class TasksController < ApplicationController
  # load_and_authorize_resource
  caches_action :index
  cache_sweeper :task_sweeper
  
  respond_to :html, :js
  
  def index
    @overdue_tasks =  @current_shelter.tasks.for_all.overdue.active.all
    @today_tasks = @current_shelter.tasks.for_all.today.active.all
    @tomorrow_tasks = @current_shelter.tasks.for_all.tomorrow.active.all
    @later_tasks = @current_shelter.tasks.for_all.later.active.all

    if @overdue_tasks.blank? and @today_tasks.blank? and @tomorrow_tasks.blank? and @later_tasks.blank?
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
    @task.attributes = params[:task]
    @changed = @task.due_date_changed?
    flash[:notice] = "Task has been updated." if @task.update_attributes(params[:task])  
    respond_with(@task)
  end
  
  def destroy
    @task = @current_shelter.tasks.find(params[:id])
    flash[:notice] = "Task has been deleted." if @task.destroy
    respond_with(@task)
  end
  
  def completed
    @task = @current_shelter.tasks.find(params[:id])   
    flash[:notice] = "Task has been completed." if @task.update_attributes({ :is_completed => true })  
    respond_with(@task)
  end

end


# def show
#   redirect_to tasks_path
# end


# rescue_from ActiveRecord::RecordNotFound do |exception|
#   logger.error(":::Attempt to access invalid task => #{params[:id]}")
#   flash[:error] = "You have requested an invalid task!"
#   redirect_to tasks_path and return
# end

# TEMPLATE CODE FOR THIS_WEEK if needed
#<b><%= task.due_date.strftime('%W') if task.due_date%></b>

