class Breed < ActiveRecord::Base
  
  # Associations
  belongs_to :animal_type, :readonly => true

  # Validations
  
  # Callbacks

  # Scopes
end
