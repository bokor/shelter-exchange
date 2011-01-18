class LocationCategoriesController < ApplicationController
  # before_filter :authenticate_user!
  respond_to :html, :js
  
  def index 
    @location_categories = @current_shelter.location_categories.all
  end
  
  def edit
    @location_category = @current_shelter.location_categories.find(params[:id])
  end
  
  def update
    @location_category = @current_shelter.location_categories.find(params[:id])
    flash[:notice] = "#{@location_category.name} has been updated." if @location_category.update_attributes(params[:location_category])
  end
  
  def create
    @location_category = @current_shelter.location_categories.new(params[:location_category])
    flash[:notice] = "#{@location_category.name} has been created." if  @location_category.save
  end
  
  def destroy
    @location_category = @current_shelter.location_categories.find(params[:id])
    @location_category.destroy
  end

end
