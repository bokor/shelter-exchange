class AnimalsController < ApplicationController
  # caches_action :index, :show 
  # cache_sweeper :animal_sweeper
  
  respond_to :html, :js
  
  def index
    @animals = @current_shelter.animals.includes(:animal_type, :animal_status).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    respond_with(@animals)
  end
  
  def show
    @animal = @current_shelter.animals.includes(:animal_type, :animal_status, :accommodation => [:location]).find(params[:id])
    @notes = @animal.notes.includes(:note_category).all
    @status_histories = @animal.status_histories.includes(:animal_status).all
    @alerts = @animal.alerts.active.all
    @overdue_tasks = @animal.tasks.overdue.active.includes(:task_category).all
  	@today_tasks = @animal.tasks.today.active.includes(:task_category).all 
  	@tomorrow_tasks = @animal.tasks.tomorrow.active.includes(:task_category).all
  	@later_tasks = @animal.tasks.later.active.includes(:task_category).all
    respond_with(@animal)
  end
  
  def edit
    @animal = @current_shelter.animals.find(params[:id])
    respond_with(@animal)
  end
  
  def new
    @animal = @current_shelter.animals.new
    respond_with(@animal)
  end
  
  def create
    @animal = @current_shelter.animals.new(params[:animal])
    flash[:notice] = "#{@animal.name} has been created." if @animal.save
    # @animal.photo.clear if @animal.photo.errors
    respond_with(@animal)
  end
  
  def update
    @animal = @current_shelter.animals.find(params[:id])
    flash[:notice] = "#{@animal.name} has been updated." if @animal.update_attributes(params[:animal]) 
    respond_with(@animal)
  end
  
  def destroy
     @animal = @current_shelter.animals.find(params[:id])
     @animal.destroy
     flash[:notice] = "#{@animal.name} has been deleted."
     respond_with(@animal)
  end
  
  def search
    q = params[:q].strip
    @animals = q.blank? ? {} : @current_shelter.animals.search(q).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
  end
  
  def filter_notes
    filter_param = params[:filter]
    @animal = @current_shelter.animals.find(params[:id])
    if filter_param.blank?
      @notes = @animal.notes
    else
      @notes = @animal.notes.animal_filter(filter_param)
    end
  end

  def filter_by_type_status
    type = params[:animal_type_id]
    status = params[:animal_status_id] 
    if type.blank? and status.blank?
      @animals = @current_shelter.animals.includes(:animal_type, :animal_status).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    elsif is_integer?(type) and status.blank?
      @animals = @current_shelter.animals.includes(:animal_type, :animal_status).where(:animal_type_id => type).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    elsif type.blank? and is_integer?(status)
      @animals = @current_shelter.animals.includes(:animal_type, :animal_status).where(:animal_status_id => status).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    elsif is_integer?(type) and is_integer?(status)
      @animals = @current_shelter.animals.includes(:animal_type, :animal_status).where(:animal_type_id => type, :animal_status_id => status).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    end
  end
  
  def auto_complete
    q = params[:q].strip
    @animals = q.blank? ? {} : @current_shelter.animals.auto_complete(q)
    render :json => @animals.collect{ |animal| {:id => animal.id, :name => "#{animal.name}" } }.to_json
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid animal => #{params[:id]}")
    flash[:error] = "You have requested an invalid animal!"
    redirect_to animals_path and return
  end
  
end