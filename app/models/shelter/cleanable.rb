module Shelter::Cleanable
  extend ActiveSupport::Concern

  included do
    before_save :clean_fields
  end


  #----------------------------------------------------------------------------
  private

  def clean_fields
    clean_status_reason
    clean_phone_numbers
  end

  def clean_status_reason
    self.status_reason = "" if self.status_changed? && self.active?
  end

  def clean_phone_numbers
    [:phone, :fax].each do |type|
      self.send(type).gsub!(/\D/, "") if self.respond_to?(type) and self.send(type).present?
    end
  end

end

