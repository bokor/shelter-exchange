class CapacitiesController < ApplicationController
  # load_and_authorize_resource
  # caches_action :index
  # cache_sweeper :capacity_sweeper
  
  respond_to :js
  
  def create
    @capacity = @current_shelter.capacities.new(params[:capacity])
    flash[:notice] = "Shelter Capacity has been created." if @capacity.save
  end
  
  def edit
    @capacity = @current_shelter.capacities.find(params[:id])
  end
  
  def update
    @capacity = @current_shelter.capacities.find(params[:id])   
    flash[:notice] = "Shelter Capacity has been updated." if @capacity.update_attributes(params[:capacity])  
  end
  
  def destroy
     @capacity = @current_shelter.capacities.find(params[:id])
     @capacity.destroy
     flash[:notice] = "Shelter Capacity has been deleted."
  end
end