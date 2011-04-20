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
  
  def animals
    
  end
  
  def find_animals_in_bounds
    @shelters = Shelter.find(:all, :bounds => [params[:sw],params[:ne]])
    @all_animals = {}
    @urgent_needs_animals = {}
    unless @shelters.blank?
      shelter_ids = @shelters.map { |shelter| shelter.id }.flatten.uniq
      @all_animals = Animal.community_all_animals(shelter_ids).active.all.paginate(:per_page => 10, :page => params[:page])
      @urgent_needs_animals = Animal.community_urgent_animals(shelter_ids).active.all.paginate(:per_page => 10, :page => params[:page])
    end
  end
  
  def find_animals_for_shelter
    @shelter = Shelter.where(:name => params[:shelter_name]).first
    @all_animals = {}
    @urgent_needs_animals = {}
    unless @shelter.blank?
      @all_animals = Animal.community_all_animals(@shelter.id).active.all.paginate(:per_page => 10, :page => params[:page])
      @urgent_needs_animals = Animal.community_urgent_animals(@shelter.id).active.all.paginate(:per_page => 10, :page => params[:page])
    end
  end
  
  
end

# render :file => filename, :content_type => 'application/rss'
