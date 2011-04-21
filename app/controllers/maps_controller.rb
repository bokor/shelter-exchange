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
    @shelters = Shelter.find(:all, :bounds => [params[:filters][:sw],params[:filters][:ne]])
    @all_animals = {}
    @urgent_needs_animals = {}
    unless @shelters.blank?
      # shelter_ids = @shelters.map { |shelter| shelter.id }.flatten.uniq
      shelter_ids = @shelters.collect(&:id)
      @all_animals = Animal.map_animals_list(shelter_ids, params[:filters]).active.all.paginate(:per_page => 10, :page => params[:page])
      @urgent_needs_animals = Animal.map_euthanasia_list(shelter_ids, params[:filters]).active.all.paginate(:per_page => 10, :page => params[:page])
    end
  end
  
  def find_animals_for_shelter
    @shelter = Shelter.where(:name => params[:filters][:shelter_name]).first
    @all_animals = {}
    @urgent_needs_animals = {}
    unless @shelter.blank?
      @all_animals = Animal.map_animals_list(@shelter.id, params[:filters]).active.all.paginate(:per_page => 10, :page => params[:page])
      @urgent_needs_animals = Animal.map_euthanasia_list(@shelter.id, params[:filters]).active.all.paginate(:per_page => 10, :page => params[:page])
    end
  end
  
  
end

# render :file => filename, :content_type => 'application/rss'
