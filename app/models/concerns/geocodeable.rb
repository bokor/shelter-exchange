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

end

