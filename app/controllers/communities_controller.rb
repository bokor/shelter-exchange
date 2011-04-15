class CommunitiesController < ApplicationController
  # caches_action :show
  # cache_sweeper :parent_sweeper
  
  respond_to :html, :js
  
  def index
    # @bounds = GeoKit::Bounds.from_point_and_radius([@current_shelter.lat,@current_shelter.lng], 2)
    # @bounds = GeoKit::Bounds.from_point_and_radius([@current_shelter.city,@current_shelter.state].join(","), 2)
    # @shelters = Shelter.find(:all, :bounds => @bounds)
  end
  
  # def search
  #   @search_by = params[:search_by]
  #   case @search_by.to_sym
  #     when :address
  #       @address_search =  params[:address]
  #       @bounds = Geokit::Geocoders::MultiGeocoder.geocode(@address_search).suggested_bounds
  #       # @bounds = GeoKit::Bounds.from_point_and_radius(@zipcode, 5)
  #       @shelters = Shelter.find(:all, :bounds => @bounds)
  #     when :shelter
  #       @shelter_search = params[:shelter]
  #       @shelter = Shelter.where(:name => @shelter_search).first.uniq
  #       @bounds = GeoKit::Bounds.from_point_and_radius([@shelter.lat,@shelter.lng].join(","), 5)
  #   end
  #   render :action => :index
  # end
  
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

end

# @shelters = Shelter.select('DISTINCT id').find(:all, :bounds => [params[:sw],params[:ne]])

# Error.select('DISTINCT type')

# sw_point = params[:sw].split(",")
# ne_point = params[:ne].split(",")
# sw = GeoKit::LatLng.new(sw_point[0], sw_point[1])
# ne = GeoKit::LatLng.new(ne_point[0], ne_point[1])
# bounds = GeoKit::Bounds.new(sw,ne)
# @shelters = Shelter.find(:all, :bounds => bounds)
# # Error.select('DISTINCT type')
# @animals = Animal.includes(:animal_type, :animal_status).where(:shelter_id => @shelters.map { |shelter| shelter.id }.flatten.uniq).all.paginate(:per_page => Animal::PER_PAGE, :page => params[:page])

