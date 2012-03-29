module Phoneable
  extend ActiveSupport::Concern
  
  included do
    before_save :format_phone_numbers
  end

  private 
    
    def format_phone_numbers
      [:phone, :fax, :mobile].each do |type|
        self.send(type).gsub!(/\D/, "") if self.respond_to?(type) and self.send(type).present?
      end
    end
end

