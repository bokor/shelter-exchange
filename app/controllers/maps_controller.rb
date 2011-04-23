class MapsController < ApplicationController
  skip_before_filter :authenticate_user!, :current_account, :current_shelter, :set_shelter_timezone
  
  respond_to :html, :js, :kml, :kmz, :georss
  # cache_sweeper :map_sweeper
  
  def overlay
    @shelters = Shelter.all
    respond_with(@shelters) do |format|  
      format.kml 
      format.kmz { 
        Zippy.new(render :kml) #{render :action => "index.kml"}
      }
      format.georss 
    end
  end
    
end

