class Breed < ActiveRecord::Base
  
  # Associations
  belongs_to :animal_type, :readonly => true

  # Validations

  # Scopes
  scope :auto_complete, lambda { |type, q|  where("animal_type_id = ? AND LOWER(name) LIKE LOWER(?)", type, "%#{q}%") }

end
