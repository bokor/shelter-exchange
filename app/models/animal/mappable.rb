module Animal::Mappable
  extend ActiveSupport::Concern
  
  included do
    
  end
  
  module ClassMethods
  
    def community_animals(shelter_ids, filters={})
      scope = self.scoped
      scope = scope.includes(:animal_type, :animal_status, :shelter)
      scope = scope.where(:shelter_id => shelter_ids)
      scope = scope.filter_euthanasia_only unless filters[:euthanasia_only].blank? or !filters[:euthanasia_only]
      scope = scope.filter_special_needs_only unless filters[:special_needs_only].blank? or !filters[:special_needs_only]
      scope = scope.filter_animal_type(filters[:animal_type]) unless filters[:animal_type].blank?
      scope = scope.filter_breed(filters[:breed]) unless filters[:breed].blank?
      scope = scope.filter_sex(filters[:sex]) unless filters[:sex].blank?
    
      scope = scope.filter_animal_status(filters[:animal_status]) unless filters[:animal_status].blank?
      scope = scope.active unless filters[:animal_status].present?
    
      scope.reorder("ISNULL(animals.euthanasia_date), animals.euthanasia_date ASC") #.limit(nil)
    end
    
    def filter_euthanasia_only
      joins(:shelter).where("shelters.is_kill_shelter = ?", true).where("animals.euthanasia_date < ?", Date.today + 2.weeks)
    end

    def filter_special_needs_only
      where(:has_special_needs => true)
    end

    def filter_animal_type(animal_type)
      where(:animal_type_id => animal_type)
    end

    def filter_breed(breed)
      where("animals.primary_breed = ? OR animals.secondary_breed = ?", breed, breed)
    end

    def filter_sex(sex)
      where(:sex => sex.downcase)
    end

    def filter_animal_status(animal_status)
      where(:animal_status_id => animal_status)
    end
  
  end

end

