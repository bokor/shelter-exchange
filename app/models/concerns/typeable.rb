module Typeable
  extend ActiveSupport::Concern

  included do |base|
    base.scope :dogs,     where(:"#{base.table_name}.animal_type_id" => AnimalType::TYPES[:dog])
    base.scope :cats,     where(:"#{base.table_name}.animal_type_id" => AnimalType::TYPES[:cat])
    base.scope :horses,   where(:"#{base.table_name}.animal_type_id" => AnimalType::TYPES[:horse])
    base.scope :rabbits,  where(:"#{base.table_name}.animal_type_id" => AnimalType::TYPES[:rabbit])
    base.scope :birds,    where(:"#{base.table_name}.animal_type_id" => AnimalType::TYPES[:bird])
    base.scope :reptiles, where(:"#{base.table_name}.animal_type_id" => AnimalType::TYPES[:reptile])
    base.scope :other,    where(:"#{base.table_name}.animal_type_id" => AnimalType::TYPES[:other])
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
    self.animal_type_id == AnimalType::TYPES[:bird]
  end

  def reptile?
    self.animal_type_id == AnimalType::TYPES[:reptile]
  end

  def other?
    self.animal_type_id == AnimalType::TYPES[:other]
  end

end

