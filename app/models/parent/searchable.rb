module Parent::Searchable
  extend ActiveSupport::Concern
  
  included do

  end
  
  module ClassMethods
    
    def search(q)
      phone = q.gsub(/\D/, "").blank? ? q : q.gsub(/\D/, "")
      where("phone = ? OR mobile = ? OR email = ? OR email_2 = ?", phone, phone, q, q).limit(10)
    end
    
  end
  
end

