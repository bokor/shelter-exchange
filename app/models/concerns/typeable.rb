module Typeable
  extend ActiveSupport::Concern
  
  included do
    
    scope :dogs, where(:animal_type_id => AnimalType::TYPES[:dog])
    scope :cats, where(:animal_type_id => AnimalType::TYPES[:cat])
    scope :horses, where(:animal_type_id => AnimalType::TYPES[:horse])
    scope :rabbits, where(:animal_type_id => AnimalType::TYPES[:rabbit])
    scope :birds, where(:animal_type_id => AnimalType::TYPES[:bird])
    scope :reptiles, where(:animal_type_id => AnimalType::TYPES[:reptile])
    scope :other, where(:animal_type_id => AnimalType::TYPES[:other])
    
  end
  
  def dog?
    self.animal_type_id == AnimalType::TYPES[:dog]
  end
  
  def cat?
    self.animal_type_id == AnimalType::TYPES[:cat]
  end
  
  def horse?
    self.animal_type_id == AnimalType::TYPES[:horse]
  end
  
  def rabbit?
    self.animal_type_id == AnimalType::TYPES[:rabbit]
  end
  
  def bird?
    self.animal_type_id == AnimalType::TYPES[:rabbit]
  end
  
  def bird?
    self.animal_type_id == AnimalType::TYPES[:bird]
  end
  
  def reptile?
    self.animal_type_id == AnimalType::TYPES[:reptile]
  end
  
  def other?
    self.animal_type_id == AnimalType::TYPES[:other]
  end
  
end
