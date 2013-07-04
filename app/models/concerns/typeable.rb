module Typeable
  extend ActiveSupport::Concern

  module ClassMethods
    def dogs
      where(:"#{self.table_name}.animal_type_id" => AnimalType::TYPES[:dog])
    end

    def cats
      where(:"#{self.table_name}.animal_type_id" => AnimalType::TYPES[:cat])
    end

    def horses
      where(:"#{self.table_name}.animal_type_id" => AnimalType::TYPES[:horse])
    end

    def rabbits
      where(:"#{self.table_name}.animal_type_id" => AnimalType::TYPES[:rabbit])
    end

    def birds
      where(:"#{self.table_name}.animal_type_id" => AnimalType::TYPES[:bird])
    end

    def reptiles
      where(:"#{self.table_name}.animal_type_id" => AnimalType::TYPES[:reptile])
    end

    def other
      where(:"#{self.table_name}.animal_type_id" => AnimalType::TYPES[:other])
    end
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

