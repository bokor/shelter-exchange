class CommunitiesController < ApplicationController
  # caches_action :show
  # cache_sweeper :parent_sweeper
  
  respond_to :html, :js
  
  def index
    # @bounds = GeoKit::Bounds.from_point_and_radius([@current_shelter.lat,@current_shelter.lng], 2)
    @bounds = GeoKit::Bounds.from_point_and_radius([@current_shelter.city,@current_shelter.state].join(","), 2)
    @shelters = Shelter.find(:all, :bounds => @bounds)
  end
  
  def search
    @search_by = params[:search_by]
    case @search_by.to_sym
      when :address
        @address_search =  params[:address]
        @bounds = Geokit::Geocoders::MultiGeocoder.geocode(@address_search).suggested_bounds
        # @bounds = GeoKit::Bounds.from_point_and_radius(@zipcode, 5)
        @shelters = Shelter.find(:all, :bounds => @bounds)
      when :shelter
        @shelter_search = params[:shelter]
        @shelter = Shelter.where(:name => @shelter_search).first
        @bounds = GeoKit::Bounds.from_point_and_radius([@shelter.lat,@shelter.lng].join(","), 5)
    end
    render :action => :index
  end

end
