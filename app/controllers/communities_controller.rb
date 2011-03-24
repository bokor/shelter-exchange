class CommunitiesController < ApplicationController
  # geocode_ip_address
  # caches_action :show
  # cache_sweeper :parent_sweeper
  
  respond_to :html, :js
  
  def index
    address = [@current_shelter.street, @current_shelter.city, @current_shelter.state, @current_shelter.zip_code].join(" ")
    # @shelters = Shelter.find(:all, :origin => address)
    @shelters = Shelter.find(:all, :origin => address, :within => 25)
    # address = [@current_shelter.street, @current_shelter.city, @current_shelter.state, @current_shelter.zip_code].join(" ")
    # @shelters = Shelter.within(25, :origin => address)
  end

end
