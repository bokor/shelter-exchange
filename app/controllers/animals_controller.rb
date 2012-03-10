class AnimalsController < ApplicationController
  respond_to :html, :js
  
  # cache_sweeper :animal_sweeper, :only => [:create, :update, :destroy]
  
  def index
    @total_animals = @current_shelter.animals.count
    @animals = @current_shelter.animals.active.includes(:animal_type, :animal_status).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    respond_with(@animals)
  end
  
  def show
    @animal = @current_shelter.animals.includes(:animal_type, :animal_status, :accommodation => [:location]).find(params[:id])
    @notes = @animal.notes.all
    @status_histories = @animal.status_histories.includes(:animal_status).all
    @alerts = @animal.alerts.active.all
    @overdue_tasks = @animal.tasks.overdue.active.all
  	@today_tasks = @animal.tasks.today.active.all
  	@tomorrow_tasks = @animal.tasks.tomorrow.active.all
  	@later_tasks = @animal.tasks.later.active.all
  	
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
    q = params[:q].strip.split.join("%")
    if q.blank?
      @animals = @current_shelter.animals.active.includes(:animal_type, :animal_status).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    else
      @animals = @current_shelter.animals.search(q).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    end
  end
  
  def filter_notes
    filter_param = params[:filter]
    @animal = @current_shelter.animals.find(params[:id])
    if filter_param.blank?
      @notes = @animal.notes.all
    else
      @notes = @animal.notes.where(:category => filter_param).all
    end
  end

  def filter_by_type_status
    @animals = @current_shelter.animals.filter_by_type_status(params[:animal_type_id], params[:animal_status_id]).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
  end
  
  def find_animals_by_name
    q = params[:q].strip
    @from_controller = params[:from_controller]
    @animals = q.blank? ? {} : @current_shelter.animals.search_by_name(q).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
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