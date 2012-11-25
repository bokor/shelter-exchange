module StreetAddressable
  extend ActiveSupport::Concern
  
  included do
    
    # Validations
    #----------------------------------------------------------------------------
    validate :full_address
  
  end

  def address_changed?
    (self.new_record?) or (self.street_changed? or self.street_2_changed? or self.city_changed? or self.state_changed? or self.zip_code_changed?)
  end

  def address_valid?
    self.street.blank? or self.city.blank? or self.state.blank? or self.zip_code.blank?
  end

  private 
    
    def full_address
      errors.add(:address, "Street, City, State and Zip code are all required") if address_valid?
    end

end
