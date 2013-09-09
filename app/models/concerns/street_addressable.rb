module StreetAddressable
  extend ActiveSupport::Concern

  included do
    validate :full_address
  end

  def address_changed?
    self.new_record? ||
    self.street_changed? ||
    self.street_2_changed? ||
    self.city_changed? ||
    self.state_changed? ||
    self.zip_code_changed?
  end

  def address_valid?
    self.street.blank? ||
    self.city.blank? ||
    self.state.blank? ||
    self.zip_code.blank?
  end

  def geocode_address
    [self.street, self.street_2, self.city, self.state, self.zip_code].compact.join(', ')
  end


  #----------------------------------------------------------------------------
  private

  def full_address
    errors.add(:address, "Street, City, State and Zip code are all required") if address_valid?
  end

end
