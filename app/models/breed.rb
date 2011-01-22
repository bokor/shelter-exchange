class Breed < ActiveRecord::Base
  
  # Associations
  belongs_to :animal_type, :readonly => true

  # Validations

  # Scopes
  scope :valid_for_animal, lambda { |breed, type|  where(:name => breed, :animal_type_id => type) }
  scope :auto_complete, lambda { |type, q|  where("animal_type_id = ? AND name LIKE ?", type, "%#{q}%") }

end
