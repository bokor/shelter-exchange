class AnimalType < ActiveRecord::Base
  
  # Associations
  has_many :animals
  has_many :breeds, :readonly => true

  # Validations
  
  # Scopes
  
end
