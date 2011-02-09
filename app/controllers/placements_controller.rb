class PlacementsController < ApplicationController
  # load_and_authorize_resource
  respond_to :js
  
  def edit
    @placement = @current_shelter.placements.find(params[:id])
  end
  
  def update
    @placement = @current_shelter.placements.find(params[:id])
    flash[:notice] = "#{Placement::PLACEMENT_TYPE[@placement.placement_type]} has been updated." if @placement.update_attributes(params[:placement])
  end
  
  def create
    @placement = @current_shelter.placements.new(params[:placement])
    flash[:notice] = "#{Placement::PLACEMENT_TYPE[@placement.placement_type]} has been created." if  @placement.save
  end
  
  def destroy
    @placement = @current_shelter.placements.find(params[:id])
    @placement.destroy
  end
  
end
