require "spec_helper"

describe Breed, "#animal_type" do

  it "should return an animal type for the breed" do
    breed = Breed.first

    breed.should respond_to(:animal_type)
    animal_type = breed.animal_type

    animal_type.id.should   == 1
    animal_type.name.should == "Dog"
  end
end

describe Breed, ".valid_for_animal" do
  #scope :valid_for_animal, lambda { |breed, type|  where(:name => breed, :animal_type_id => type) }
end

describe Breed, ".auto_complete" do
  #scope :auto_complete, lambda { |type, q|  where(:animal_type_id => type).where("name LIKE ?", "%#{q}%") }
end

describe Breed, ".dogs" do
  #scope :dogs, where(:animal_type_id => AnimalType::TYPES[:dog])
end

describe Breed, ".cats" do
  #scope :cats, where(:animal_type_id => AnimalType::TYPES[:cat])
end

describe Breed, ".horses" do
  #scope :horses, where(:animal_type_id => AnimalType::TYPES[:horse])
end

describe Breed, ".rabbits" do
  #scope :rabbits, where(:animal_type_id => AnimalType::TYPES[:rabbit])
end

describe Breed, ".birds" do
  #scope :birds, where(:animal_type_id => AnimalType::TYPES[:bird])
end

describe Breed, ".reptiles" do
  #scope :reptiles, where(:animal_type_id => AnimalType::TYPES[:reptile])
end

describe Breed, ".other" do
  #scope :other, where(:animal_type_id => AnimalType::TYPES[:other])
end

describe Breed, "#dog?" do
  #def dog?
    #self.animal_type_id == AnimalType::TYPES[:dog]
  #end
end

describe Breed, "#cat?" do
  #def cat?
    #self.animal_type_id == AnimalType::TYPES[:cat]
  #end
end

describe Breed, "#horse?" do
  #def horse?
    #self.animal_type_id == AnimalType::TYPES[:horse]
  #end
end

describe Breed, "#rabbit?" do
  #def rabbit?
    #self.animal_type_id == AnimalType::TYPES[:rabbit]
  #end
end

describe Breed, "#bird?" do
  #def bird?
    #self.animal_type_id == AnimalType::TYPES[:bird]
  #end
end

describe Breed, "#reptile?" do
  #def reptile?
    #self.animal_type_id == AnimalType::TYPES[:reptile]
  #end
end

describe Breed, "#other?" do
  #def other?
    #self.animal_type_id == AnimalType::TYPES[:other]
  #end
end

