class TasksController < ApplicationController
  # before_filter :authenticate_user!
  respond_to :html, :js
  
  def index
    # @tasks = Task.for_global.all
    @overdue_tasks =  @current_shelter.tasks.for_all.overdue.not_completed.all
    @today_tasks = @current_shelter.tasks.for_all.today.not_completed.all
    @tomorrow_tasks = @current_shelter.tasks.for_all.tomorrow.not_completed.all
    @later_tasks = @current_shelter.tasks.for_all.later.not_completed.all

    if @overdue_tasks.blank? and @today_tasks.blank? and @tomorrow_tasks.blank? and @later_tasks.blank?
      @task = @current_shelter.tasks.new
      respond_with(@task)
    else
      @task_validate = true
    end  
  end
  
  # def show
  #   redirect_to tasks_path and return
  # end
  
  def edit
    begin
      @task = @current_shelter.tasks.find(params[:id])
      respond_with(@task)
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid task => #{params[:id]}")
      flash[:error] = "You have requested an invalid task!"
      redirect_to tasks_path and return
    end
  end
  
  
  # def new
  #   @task = Task.new
  #   respond_with(@task)
  # end
  
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
    @changed = @task.due_category_changed?
    flash[:notice] = "Task has been updated." if @task.update_attributes(params[:task])  
    respond_with(@task)
  end
  
  def destroy
    @task = @current_shelter.tasks.find(params[:id])
    @task.destroy
    flash[:notice] = "Task has been deleted."
    respond_with(@task)
  end
  
  def completed
    @task = @current_shelter.tasks.find(params[:id])   
    flash[:notice] = "Task has been completed." if @task.update_attributes({ :is_completed => true })  
    respond_with(@task)
  end

end

# TEMPLATE CODE FOR THIS_WEEK if needed
#<b><%= task.due_date.strftime('%W') if task.due_date%></b>

