class CapacitiesController < ApplicationController
  # load_and_authorize_resource
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
  
  def show
    redirect_to capacities_path and return
  end
  
  def new
    redirect_to capacities_path and return
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
  
  # rescue_from ActiveRecord::RecordNotFound do |exception|
  #   logger.error(":::Attempt to access invalid alert => #{params[:id]}")
  #   flash[:error] = "You have requested an invalid alert!"
  #   redirect_to capacities_path and return
  # end


end