class LocationsController < ApplicationController
  # before_filter :authenticate_user!
  respond_to :html, :js
  
  def index
    @locations = @current_shelter.locations.all(:include => [:animal_type])
    @tags = @current_shelter.owned_tags.order("tags.name ASC")

    if @locations.blank?
      @location = @current_shelter.locations.new
      respond_with(@location)
    else
      @location_validate = true
    end  
  end
  
  # def show
  #   redirect_to locations_path and return
  # end
  
  def edit
    begin
      @location = @current_shelter.locations.find(params[:id])
      respond_with(@location)
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid location => #{params[:id]}")
      flash[:error] = "You have requested an invalid location!"
      redirect_to locations_path and return
    end
  end
  
  
  # def new
  #   @location = Task.new
  #   respond_with(@location)
  # end
  
  def create
    @location = @current_shelter.locations.new(params[:location])
    @current_shelter.tag(@location, :with => @location.tag_list, :on => :tags)
    
    respond_with(@location) do |format|
      if @location.save
        flash[:notice] = "#{@location.name} location has been created."
        @tags = @current_shelter.owned_tags.order("tags.name ASC")
        format.html { render :action => :index }
      else
        format.html { render :action => :index }
      end
    end
  end
  
  def update
    @location = @current_shelter.locations.find(params[:id])   
    @current_shelter.tag(@location, :with => @location.tag_list, :on => :tags)
    flash[:notice] = "#{@location.name} location has been updated." if @location.update_attributes(params[:location])  
    @tags = @current_shelter.owned_tags.order("tags.name ASC")
    respond_with(@location)
  end
  
  def destroy
    @location = @current_shelter.locations.find(params[:id])
    @location.destroy
    flash[:notice] = "#{@location.name} location has been deleted."
    @tags = @current_shelter.owned_tags.order("tags.name ASC")
    respond_with(@location)
  end
  
  def find_by
    # TODO - look to move this function into the model.
    type = params[:animal_type_id]
    if type.empty?
      @locations = @current_shelter.locations.all
    else
      @locations = @current_shelter.locations.scoped_by_animal_type_id(type)
    end
  end
  
  def find_tags
    q = params[:q].strip
    @tags = @current_shelter.owned_tags.where("tags.name like '%#{q}%'").order("tags.name ASC")
    # render :json => @tags.collect{ |tag| {:id => "#{tag.id}", :name => "#{tag.name}" } }
    render :json => @tags.collect{ |tag| {:id => "#{tag.id}", :label => "#{tag.name}", :value => "#{tag.name}", :name => "#{tag.name}" } }
  end

end
