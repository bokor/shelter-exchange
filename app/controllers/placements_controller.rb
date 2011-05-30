class PlacementsController < ApplicationController
  respond_to :js
  
  def create
    @placement = @current_shelter.placements.new(params[:placement])
    flash[:notice] = "#{@placement.status.humanize} has been created." if @placement.save
  end
  
  def edit
    @placement = @current_shelter.placements.find(params[:id])
  end
  
  def update
    @placement = @current_shelter.placements.find(params[:id])
    flash[:notice] = "#{@placement.status.humanize} has been updated." if @placement.update_attributes(params[:placement])
  end
  
  def destroy
    @placement = @current_shelter.placements.find(params[:id])
    @placement.destroy
  end
  
end
