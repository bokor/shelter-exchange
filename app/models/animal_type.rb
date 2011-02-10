class AnimalType < ActiveRecord::Base
  
  # Associations
  has_many :animals
  has_many :breeds, :readonly => true
  has_many :accommodations
  has_many :capacities

  # Validations
  
  # Scopes
  
end
