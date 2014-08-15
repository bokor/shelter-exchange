module Geocodeable
  extend ActiveSupport::Concern

  included do

    # Plugins
    #----------------------------------------------------------------------------
    geocoded_by :geocode_address, :latitude  => :lat, :longitude => :lng

    # Callbacks
    #----------------------------------------------------------------------------
    after_validation :geocode, :if => :address_changed?
  end

  def address_changed?
    self.new_record? ||
    self.street_changed? ||
    self.street_2_changed? ||
    self.city_changed? ||
    self.state_changed? ||
    self.zip_code_changed?
  end

  def geocode_address
    [self.street, self.street_2, self.city, self.state, self.zip_code].compact.join(', ')
  end
end

