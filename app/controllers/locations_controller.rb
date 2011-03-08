class LocationsController < ApplicationController
  # caches_action :find_all
  # cache_sweeper :location_sweeper
  
  respond_to :js
  
  def create
    @location = @current_shelter.locations.new(params[:location])
    flash[:notice] = "#{@location.name} has been created." if  @location.save
  end
  
  def edit
    @location = @current_shelter.locations.find(params[:id])
  end
  
  def update
    @location = @current_shelter.locations.find(params[:id])
    flash[:notice] = "#{@location.name} has been updated." if @location.update_attributes(params[:location])
  end
  
  def destroy
    @location = @current_shelter.locations.find(params[:id])
    @location.destroy
  end
  
  def find_all
    @locations = @current_shelter.locations.all
  end

end
