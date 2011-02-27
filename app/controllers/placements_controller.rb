class PlacementsController < ApplicationController
  # load_and_authorize_resource
  respond_to :js
  
  def edit
    @placement = @current_shelter.placements.find(params[:id])
  end
  
  def update
    @placement = @current_shelter.placements.find(params[:id])
    flash[:notice] = "#{@placement.placement_type.humanize} has been updated." if @placement.update_attributes(params[:placement])
  end
  
  def create
    @placement = @current_shelter.placements.new(params[:placement])
    flash[:notice] = "#{@placement.placement_type.humanize} has been created." if  @placement.save
  end
  
  def destroy
    @placement = @current_shelter.placements.find(params[:id])
    @placement.destroy
  end
  
end
