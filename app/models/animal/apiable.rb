module Animal::Apiable
  extend ActiveSupport::Concern
  
  included do
  
  end
  
  module ClassMethods
    
    def api_lookup(types, statuses)
        scope = self.scoped
        scope = scope.includes(:animal_type, :animal_status)
        scope = (statuses.blank? ? scope.available_for_adoption : scope.where(:animal_status_id => statuses))
        scope = scope.where(:animal_type_id => types) unless types.blank?
        scope.reorder("ISNULL(animals.euthanasia_date), animals.euthanasia_date ASC").limit(nil)
      end
  
  end
  

end

