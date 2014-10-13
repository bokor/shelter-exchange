module Uploadable
  extend ActiveSupport::Concern

  included do

    # Callbacks
    #----------------------------------------------------------------------------
    before_validation :generate_guid!
    before_validation :generate_timestamp!

    # Getters/Setters
    #----------------------------------------------------------------------------
    attr_accessor :guid
    attr_accessor :timestamp
  end

  def generate_guid!(length=8)
    self.guid = SecureRandom.hex(length) if self.guid.blank?
  end

  def generate_timestamp!
    self.timestamp = Time.now.to_i if self.timestamp.blank?
  end
end

