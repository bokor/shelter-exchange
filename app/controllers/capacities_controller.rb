class CapacitiesController < ApplicationController
  respond_to :html, :js

  def index
    @capacities = @current_shelter.capacities.includes(:animal_type).all
    redirect_to new_capacity_path if @capacities.blank?
  end

  def new
    @capacity = @current_shelter.capacities.new
    respond_with(@capacity)
  end

  def create
    @capacity = @current_shelter.capacities.new(params[:capacity])
    respond_with(@capacity) do |format|
      if @capacity.save
        flash[:notice] = "Shelter Capacity has been created."
        format.html { redirect_to capacities_path }
      else
        format.html { render :action => :new }
      end
    end
  end

  def edit
    @capacity = @current_shelter.capacities.find(params[:id])
    respond_with(@capacity)
  end

  def update
    @capacity = @current_shelter.capacities.find(params[:id])
    flash[:notice] = "Shelter Capacity has been updated." if @capacity.update_attributes(params[:capacity])
    respond_with(@capacity)
  end

  def destroy
    @capacity = @current_shelter.capacities.find(params[:id])
    flash[:notice] = "Shelter Capacity has been deleted." if @capacity.destroy
    respond_with(@capacity)
  end

end

