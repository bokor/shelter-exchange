class AnimalType < ActiveRecord::Base
  
  # Associations
  has_many :animals, :readonly => true
  has_many :breeds, :readonly => true
  has_many :accommodations, :readonly => true
  has_many :capacities, :readonly => true
  
end
