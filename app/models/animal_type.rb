class AnimalType < ActiveRecord::Base
  
  # Associations
  has_many :animals
  has_many :breeds, :readonly => true
  has_many :locations

  # Validations
  
  # Scopes
  
end
