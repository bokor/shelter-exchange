module Geocodeable
  extend ActiveSupport::Concern
  include StreetAddressable

  included do

    # Plugins
    #----------------------------------------------------------------------------
    geocoded_by :geocode_address, :latitude  => :lat, :longitude => :lng

    # Callbacks
    #----------------------------------------------------------------------------
    after_validation :geocode, :if => :address_changed?
  end
end

