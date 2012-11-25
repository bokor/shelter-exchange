module Geocodeable
  extend ActiveSupport::Concern
  include StreetAddressable
  
  included do
      
    # Plugins
    #----------------------------------------------------------------------------
    geocoded_by :geocode_address, 
                :latitude  => :lat, :longitude => :lng
    
    # Callbacks
    #----------------------------------------------------------------------------
    after_validation :geocode

  end

  module ClassMethods

    def within_bounds(sw, ne)
      sw_lat = sw[0].to_f
      ne_lat = ne[0].to_f
      sw_lng = sw[1].to_f
      ne_lng = ne[1].to_f

      operator = sw_lng > ne_lng ? 'OR' : 'AND'

      where("#{self.table_name}.lat > ? AND #{self.table_name}.lat < ?", sw_lat, ne_lat).
      where("#{self.table_name}.lng < ? #{operator} #{self.table_name}.lng > ?", ne_lng, sw_lng)
    end
  end
  
  def geocode_address
    [self.street, self.city, self.state, self.zip_code].join(" ")    
  end
end

  #GEOCODER SQL
      #   if sw_lng > ne_lng
      #   where("shelters.lat BETWEEN #{sw_lat} AND #{ne_lat}").where("shelters.lng BETWEEN #{sw_lng} AND 180 OR shelters.lng BETWEEN -180 AND #{ne_lng}")
      # else
      #   where("shelters.lat BETWEEN #{sw_lat} AND #{ne_lat}").where("shelters.lng BETWEEN #{sw_lng} AND #{ne_lng}")
      # end