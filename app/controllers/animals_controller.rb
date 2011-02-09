class AnimalsController < ApplicationController
  # before_filter :authenticate_user!
  respond_to :html, :js
  
  def index
    @animals = @current_shelter.animals.includes(:animal_type, :animal_status).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    respond_with(@animals)
  end
  
  def show
    begin
      @animal = @current_shelter.animals.includes(:animal_type, :animal_status, :notes => [:note_category], :accommodation => [:location]).find(params[:id])
      # @animal = @current_shelter.animals.includes(:animal_type, :animal_status, :alerts, :accommodation => [:location], :notes => [:note_category], :tasks => [:task_category]).find(params[:id])
      @alerts = @animal.alerts.not_stopped.all
      @overdue_tasks = @animal.tasks.overdue.not_completed.includes(:task_category).all
  		@today_tasks = @animal.tasks.today.not_completed.includes(:task_category).all 
  		@tomorrow_tasks = @animal.tasks.tomorrow.not_completed.includes(:task_category).all
  		@later_tasks = @animal.tasks.later.not_completed.includes(:task_category).all
      respond_with(@animal)
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid animal => #{params[:id]}")
      flash[:error] = "You have requested an invalid animal!"
      redirect_to animals_path and return
    end
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
  
  def full_search
    q = params[:q].strip
    @animals = q.blank? ? {} : @current_shelter.animals.full_search(q).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
  end
  
  def search_by_name
    q = params[:q].strip
    @animals = q.blank? ? {} : @current_shelter.animals.search_by_name(q).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
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
  # move to the model where(:animal_type_id => type)
  def filter_by_type_status
    type = params[:animal_type_id]
    status = params[:animal_status_id] 
    if type.blank? and status.blank?
      @animals = @current_shelter.animals.includes(:animal_type, :animal_status).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    elsif is_integer(type) and status.blank?
      @animals = @current_shelter.animals.where(:animal_type_id => type).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    elsif type.blank? and is_integer(status)
      @animals = @current_shelter.animals.where(:animal_status_id => status).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    elsif is_integer(type) and is_integer(status)
      @animals = @current_shelter.animals.where(:animal_type_id => type, :animal_status_id => status).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
    end
  end
  
  def auto_complete
    q = params[:q].strip
    @animals = q.blank? ? {} : @current_shelter.animals.auto_complete(q)
    render :json => @animals.collect{ |animal| {:id => "#{animal.id}", :label => "#{animal.name}", :value => "#{animal.name}", :name => "#{animal.name}" } }
  end
  
end

  
  
  # def api
  #   @animals = Animal.all
  #   respond_to do |format|  
  #             format.json {
  #               render :json => @animals.to_json(:include => [:animal_type,:animal_status], :except =>[:id,:animal_type_id, :animal_status_id])
  #             }
  #           end
  # end
  
  # LIVE SEARCH OTHER CODE
  # TODO - Figure out a way if a shelter were to type text that each string might add an AND statement and another set of ORs
  # ALSO - look to move this function into the model.
  # temp = params[:q].strip.split
  # q = temp.map {|str| str}.join("%")
  # @animals = Animal.where("LOWER(name) LIKE LOWER('%#{q}%') OR LOWER(description) LIKE LOWER('%#{q}%') OR LOWER(chip_id) LIKE LOWER('%#{q}%') OR LOWER(color) LIKE LOWER('%#{q}%') OR LOWER(primary_breed) LIKE LOWER('%#{q}%') OR LOWER(secondary_breed) LIKE LOWER('%#{q}%')").paginate :per_page => Animal::PER_PAGE, :page => params[:page]
  

