module Accommodation::Searchable
  extend ActiveSupport::Concern

  included do
    scope :search, lambda { |q|
      includes(:animal_type, :location, :animals => [:photos, :animal_status]).where("name LIKE ?", "%#{q}%")
    }
  end

  module ClassMethods

    def filter_by_type_location(type, location)
      scope = scoped{}
      scope = scope.includes(:animal_type, :location, :animals => [:photos, :animal_status])
      scope = scope.where(:animal_type_id => type) unless type.blank?
      scope = scope.where(:location_id => location) unless location.blank?
      scope
    end
  end

end

