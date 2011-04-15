class SheltersController < ApplicationController
  load_and_authorize_resource :only => [:edit]
  # caches_action :index
  # cache_sweeper :shelter_sweeper
  
  respond_to :html, :js, :json
  
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
        @shelter.logo.clear if @shelter.logo.errors
        format.html { render :action => :edit }
      end
    end
  end
   
  def auto_complete
    q = params[:q].strip
    @shelters = Shelter.auto_complete(q)
    render :json => @shelters.collect{ |shelter| {:id => shelter.id, :name => "#{shelter.name}" } }.to_json
  end
  
end