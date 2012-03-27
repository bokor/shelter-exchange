module Geocodeable
  extend ActiveSupport::Concern
  include StreetAddressable
  
  included do
      
    # Plugins
    #----------------------------------------------------------------------------
    acts_as_mappable
    
    # Callbacks
    #----------------------------------------------------------------------------
    before_save :geocode!

  end
  
  def geocode_address
    Geokit::Geocoders::MultiGeocoder.geocode ([self.street, self.city, self.state, self.zip_code].join(" "))
  end

  private 

    def geocode!
      if address_changed?
        geo = geocode_address
        errors.add(:street, "Could not Geocode address") if !geo.success
        self.lat, self.lng = geo.lat, geo.lng if geo.success
      end
    end


end

