class LocationsController < ApplicationController
  # before_filter :authenticate_user!
  respond_to :html, :js
  
  def index
    @locations = @current_shelter.locations.all

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
    # @current_shelter.tag(@location, :with => params[:tag_list], :on => :locations)
    
    respond_with(@location) do |format|
      if @location.save
        flash[:notice] = "#{@location.name} location has been created."
        format.html { redirect_to locations_path }
      else
        format.html { render :action => :index }
      end
    end
  end
  
  def update
    @location = @current_shelter.locations.find(params[:id])   
    flash[:notice] = "#{@location.name} location has been updated." if @location.update_attributes(params[:location])  
    respond_with(@location)
  end
  
  def destroy
    @location = @current_shelter.locations.find(params[:id])
    @location.destroy
    flash[:notice] = "#{@location.name} location has been deleted."
    respond_with(@location)
  end

end
