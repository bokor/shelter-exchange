class TasksController < ApplicationController
  respond_to :html, :js
  
  def index
    @overdue_tasks =  @current_shelter.tasks.overdue.active.includes(:taskable).all
    @today_tasks = @current_shelter.tasks.today.active.includes(:taskable).all
    @tomorrow_tasks = @current_shelter.tasks.tomorrow.active.includes(:taskable).all
    @later_tasks = @current_shelter.tasks.later.active.includes(:taskable).all

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
  
  def complete
    @task = @current_shelter.tasks.find(params[:id])   
    flash[:notice] = "Task has been completed." if @task.update_attributes({ :completed => true })  
    respond_with(@task)
  end

end

# @tasks =  @current_shelter.tasks.for_all.active
# @overdue_tasks =  []
# @today_tasks =  []
# @tomorrow_tasks =  []
# @later_tasks =  []
# 
# @tasks.each{|task| 
#   @overdue_tasks <<  task if task.overdue?
#   @today_tasks <<  task if task.today?
#   @tomorrow_tasks << task if task.tomorrow?
#   @later_tasks <<  task if task.later?
# }
# 
# if @tasks.blank?
#   redirect_to new_task_path
# end