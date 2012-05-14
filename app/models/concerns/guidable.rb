module Guidable
  extend ActiveSupport::Concern
  
  included do
    
    # Callbacks
    #----------------------------------------------------------------------------
    before_validation :generate_guid!
    
    # Getters/Setters
    #----------------------------------------------------------------------------
    attr_accessor :guid 

  end
  
  def generate_guid!(length=8)
    self.guid = SecureRandom.hex(length) if self.guid.blank?
  end
  
end
