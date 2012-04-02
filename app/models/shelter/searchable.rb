module Shelter::Searchable
  extend ActiveSupport::Concern
  
  included do

  end
  
  module ClassMethods
    
    def live_search (q, shelter)
      scope = self.scoped
      scope = scope.where(shelter)
      scope = scope.where("name LIKE ? OR city LIKE ? OR zip_code LIKE ? OR 
                           facebook LIKE ? OR twitter LIKE ? or email LIKE ?", 
                           "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%") unless q.blank?
      scope
    end
    
  end
  
end

