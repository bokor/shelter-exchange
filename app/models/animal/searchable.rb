module Animal::Searchable
  extend ActiveSupport::Concern

  included do

    scope :auto_complete, lambda { |q| includes(:animal_type, :animal_status).where("name LIKE ?", "%#{q}%") }
    scope :search, lambda { |q|
      includes(:animal_type, :animal_status, :photos).
      where("animals.id LIKE ? OR animals.name LIKE ? OR animals.description LIKE ? OR
             animals.microchip LIKE ? OR animals.color LIKE ? OR animals.weight LIKE ? OR
             animals.primary_breed LIKE ? OR animals.secondary_breed LIKE ?",
             "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%")
    }
  end

  module ClassMethods

    def search_by_name(q)
      scope = self.scoped
      scope = scope.includes(:animal_type, :animal_status, :photos)
      if q.is_numeric?
        scope = scope.where(:"animals.id" => q)
      else
        scope = scope.where("animals.name LIKE ?", "%#{q}%")
      end

      scope
    end

    def filter_by_type_status(type, status)
      scope = self.scoped
      scope = scope.includes(:animal_type, :animal_status, :photos)
      scope = scope.where(:animal_type_id => type) unless type.blank?
      unless status.blank?
        scope = (status == "active" or status == "non_active") ? scope.send(status) : scope.where(:animal_status_id => status)
      end

      scope
    end
  end
end

