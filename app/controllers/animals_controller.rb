class AnimalsController < ApplicationController
  respond_to :html, :js
  
  def index
    @animals = Animal.all.paginate :per_page => Animal::PER_PAGE, :page => params[:page]
    respond_with(@animals)
  end
  
  def show
    begin
      session[:scope] = nil
      @animal = Animal.find(params[:id])
      respond_with(@animal)
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid animal => #{params[:id]}")
      flash[:error] = "You have requested an invalid animal!"
      redirect_to animals_path and return
    end
  end
  
  def edit
    @animal = Animal.find(params[:id])
    respond_with(@animal)
  end
  
  def new
    @animal = Animal.new
    respond_with(@animal)
  end
  
  def create
    @animal = Animal.new(params[:animal])
    flash[:notice] = "#{@animal.name} has been created." if @animal.save
    respond_with(@animal)
  end
  
  def update
    @animal = Animal.find(params[:id])
    flash[:notice] = "#{@animal.name} has been updated." if @animal.update_attributes(params[:animal])      
    respond_with(@animal)
  end
  
  def destroy
     @animal = Animal.find(params[:id])
     @animal.destroy
     flash[:error] = "#{@animal.name} has been deleted."
     respond_with(@animal)
  end
  
  def scoped_notes_for_animal
    @animal = Animal.find(params[:id])
    @scope = params[:scope]
    if @scope.blank?
      @notes = @animal.notes
    else
      @notes = @animal.notes.animal_filter(@scope)
    end
    session[:scope] = @scope
  end
  
  def live_search
    q = params[:q].strip
    # TODO - Figure out a way if a shelter were to type text that each string might add an AND statement and another set of ORs
    # ALSO - look to move this function into the model.
    # temp = params[:q].strip.split
    # q = temp.map {|str| str}.join("%")
    # @animals = Animal.where("LOWER(name) LIKE LOWER('%#{q}%') OR LOWER(description) LIKE LOWER('%#{q}%') OR LOWER(chip_id) LIKE LOWER('%#{q}%') OR LOWER(color) LIKE LOWER('%#{q}%') OR LOWER(primary_breed) LIKE LOWER('%#{q}%') OR LOWER(secondary_breed) LIKE LOWER('%#{q}%')").paginate :per_page => Animal::PER_PAGE, :page => params[:page]
    @animals = Animal.live_search(q).paginate :per_page => Animal::PER_PAGE, :page => params[:page]
  end
  
  def find_by
    # TODO - look to move this function into the model.
    type = params[:animal_type_id]
    status = params[:animal_status_id] 
    if type.empty? and status.empty?
      @animals = Animal.all.paginate :per_page => Animal::PER_PAGE, :page => params[:page]
    elsif is_integer(type) and status.empty?
      @animals = Animal.scoped_by_animal_type_id(type).paginate :per_page => Animal::PER_PAGE, :page => params[:page]
    elsif type.empty? and is_integer(status)
      @animals = Animal.scoped_by_animal_status_id(status).paginate :per_page => Animal::PER_PAGE, :page => params[:page]
    elsif is_integer(type) and is_integer(status)
      @animals = Animal.scoped_by_animal_type_id_and_animal_status_id(type,status).paginate :per_page => Animal::PER_PAGE, :page => params[:page]
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
  
end
