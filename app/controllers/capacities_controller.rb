class CapacitiesController < ApplicationController
  # load_and_authorize_resource
  # caches_action :index
  # cache_sweeper :capacity_sweeper
  
  respond_to :html, :js
  
  def index
    @capacities = @current_shelter.capacities.includes(:animal_type).all

    if @capacities.blank?
      @capacity = @current_shelter.capacities.new
      respond_with(@capacity)
    else
      @capacity_validate = true
    end
  end
  
  def edit
    @capacity = @current_shelter.capacities.find(params[:id])
    respond_with(@capacity)
  end
  
  def create
    @capacity = @current_shelter.capacities.new(params[:capacity])
    
    respond_with(@capacity) do |format|
      if @capacity.save
        flash[:notice] = "Shelter Capacity has been created."
        format.html { redirect_to capacities_path }
      else
        format.html { render :action => :index }
      end
    end
  end
  
  def update
    @capacity = @current_shelter.capacities.find(params[:id])   
    respond_with(@capacity) do |format|
      if @capacity.update_attributes(params[:capacity])  
        flash[:notice] = "Shelter Capacity has been updated."
        format.html { redirect_to capacities_path }
      else
        format.html { render :action => :edit }
      end
    end
  end
  
  def destroy
     @capacity = @current_shelter.capacities.find(params[:id])
     @capacity.destroy
     flash[:notice] = "Shelter Capacity has been deleted."
     respond_with(@capacity)
  end
end