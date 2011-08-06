class Breed < ActiveRecord::Base
  
  # Associations
  #----------------------------------------------------------------------------
  belongs_to :animal_type, :readonly => true

  # Scopes
  #----------------------------------------------------------------------------
  scope :valid_for_animal, lambda { |breed, type|  where(:name => breed, :animal_type_id => type) }
  scope :auto_complete, lambda { |type, q|  where(:animal_type_id => type).where("LOWER(name) LIKE LOWER(?)", "%#{q}%") }
  
  scope :dogs, where(:animal_type_id => AnimalType::TYPES[:dog])
  scope :cats, where(:animal_type_id => AnimalType::TYPES[:cat])
  scope :horses, where(:animal_type_id => AnimalType::TYPES[:horse])
  scope :rabbits, where(:animal_type_id => AnimalType::TYPES[:rabbit])
  scope :birds, where(:animal_type_id => AnimalType::TYPES[:bird])
  scope :reptiles, where(:animal_type_id => AnimalType::TYPES[:reptile])
  scope :other, where(:animal_type_id => AnimalType::TYPES[:other])

end
