class LocationsController < ApplicationController
  # load_and_authorize_resource
  respond_to :html, :js
  
  def index 
    @locations = @current_shelter.locations.all
  end
  
  def edit
    @location = @current_shelter.locations.find(params[:id])
  end
  
  def update
    @location = @current_shelter.locations.find(params[:id])
    flash[:notice] = "#{@location.name} has been updated." if @location.update_attributes(params[:location])
  end
  
  def create
    @location = @current_shelter.locations.new(params[:location])
    flash[:notice] = "#{@location.name} has been created." if  @location.save
  end
  
  def destroy
    @location = @current_shelter.locations.find(params[:id])
    @location.destroy
  end

end
