class SheltersController < ApplicationController
  # load_and_authorize_resource
  # caches_action :index
  # cache_sweeper :shelter_sweeper
  
  respond_to :html, :js
  
  def index
    respond_with(@shelter = @current_shelter)
  end
  
  def edit
    respond_with(@shelter = @current_shelter)
  end
  
  def update
    respond_with(@shelter  = @current_shelter) do |format|
      if @shelter.update_attributes(params[:shelter])  
        flash[:notice] = "#{@shelter.name} has been updated."
        format.html { redirect_to shelters_path }
      else
        format.html { render :action => :edit }
      end
    end
  end
  
end