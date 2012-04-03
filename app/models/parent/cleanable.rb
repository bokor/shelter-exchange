module Parent::Cleanable
  extend ActiveSupport::Concern
  
  included do
    
    before_save :clean_fields
    
  end
  
  private
    def clean_fields
      clean_phone_numbers
    end
    
    def clean_phone_numbers
      [:phone, :mobile].each do |type|
        self.send(type).gsub(/\D/, "") if self.respond_to?(type) and self.send(type).present?
      end
    end

end

