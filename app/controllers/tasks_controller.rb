class TasksController < ApplicationController
  respond_to :html, :js
  
  def index
    # @tasks = Task.for_global.all
    @overdue_tasks =  Task.global.overdue.not_completed.all
    @today_tasks = Task.global.today.not_completed.all
    @tomorrow_tasks = Task.global.tomorrow.not_completed.all
    @later_tasks = Task.global.later.not_completed.all

    if @overdue_tasks.blank? and @today_tasks.blank? and @tomorrow_tasks.blank? and @later_tasks.blank?
      @task = Task.new
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
      @task = Task.find(params[:id])
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
    @task.attributes = params[:task]
    @changed = @task.due_category_changed?
    flash[:notice] = "Task has been updated." if @task.update_attributes(params[:task])  
    respond_with(@task)
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:error] = "Task has been deleted."
    respond_with(@task)
  end
  
  def completed
    @task = Task.find(params[:id])   
    @task.attributes = params[:task]
    @task.is_completed = true
    flash[:notice] = "Task has been completed." if @task.update_attributes(@task.attributes)  
    respond_with(@task)
  end
  
  # def task_count_by_scope
  #   if @task.due_date.blank? or @task.due_date > Date.today + 1.day or @task.due_category == 'later'
  #     @count = Task.later.all.count
  #   elsif @task.due_date < Date.today
  #     @count = Task.overdue.all.count
  #   elsif @task.due_date == Date.today
  #     @count = Task.today.all.count
  #   elsif @task.due_date == Date.today + 1.day
  #     @count = Task.tomorrow.all.count
  #   end
  # end

end

# TEMPLATE CODE FOR THIS_WEEK if needed
#<b><%= task.due_date.strftime('%W') if task.due_date%></b>

