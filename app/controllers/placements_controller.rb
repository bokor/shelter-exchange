class PlacementsController < ApplicationController
  respond_to :js
  
  def create
    @placement = @current_shelter.placements.new(params[:placement])
    flash[:notice] = "#{@placement.status.humanize} has been created." if @placement.save
  end
    
  def destroy
    @placement = @current_shelter.placements.find(params[:id])
    @placement.destroy
  end
  
  def find_comments
    @comments = Placement.find(params[:id]).comments.all
  end
  
end
