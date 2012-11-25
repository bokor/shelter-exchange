module Geocodeable
  extend ActiveSupport::Concern
  include StreetAddressable
  
  included do
      
    # Plugins
    #----------------------------------------------------------------------------
    geocoded_by :geocode_address
    
    # Callbacks
    #----------------------------------------------------------------------------
    after_validation :geocode

  end
  
  def geocode_address
    [self.street, self.city, self.state, self.zip_code].join(" ")    
  end
end

