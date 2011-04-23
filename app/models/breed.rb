class Breed < ActiveRecord::Base
  
  # Associations
  belongs_to :animal_type, :readonly => true

  # Scopes
  scope :valid_for_animal, lambda { |breed, type|  where(:name => breed, :animal_type_id => type) }
  scope :auto_complete, lambda { |type, q|  where(:animal_type_id => type).where("LOWER(name) LIKE LOWER(?)", "%#{q}%") }

end
