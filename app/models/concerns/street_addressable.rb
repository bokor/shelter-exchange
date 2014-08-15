module StreetAddressable
  extend ActiveSupport::Concern

  included do
    validate :full_address
  end

  #----------------------------------------------------------------------------
  private

  def address_valid?
    self.street.blank? || self.city.blank? || self.state.blank? || self.zip_code.blank?
  end

  def full_address
    errors.add(:address, "Street, City, State and Zip code are all required") if address_valid?
  end
end

