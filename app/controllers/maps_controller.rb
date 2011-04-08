class MapsController < ApplicationController
  skip_before_filter :authenticate_user!, :current_account, :current_shelter, :set_shelter_timezone
  
  respond_to :kml, :georss
  # cache_sweeper :map_sweeper
  
  def index
    @shelters = Shelter.all
    respond_with(@shelters) do |format|  
      format.kml 
      format.georss 
    end
  end
end
