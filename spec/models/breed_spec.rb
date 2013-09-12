require "spec_helper"

describe Breed do
  it_should_behave_like Typeable
end

# Class Methods
#----------------------------------------------------------------------------
describe Breed, ".valid_for_animal" do

  it "validates the breed exists with the type" do
    animal_type = AnimalType.gen
    Breed.gen :name => "Labrador Retriever", :animal_type => animal_type

    validation1 = Breed.valid_for_animal("Labrador Retriever", animal_type.id)
    validation2 = Breed.valid_for_animal("Labrador Retriever", 100000)

    validation1.count.should == 1
    validation2.count.should == 0
  end
end

describe Breed, ".auto_complete" do

  it "returns the correct breeds per animal type" do
    animal_type = AnimalType.gen

    breed1 = Breed.gen :name => "Labrador Retriever", :animal_type => animal_type
    breed2 = Breed.gen :name => "Labrador Husky", :animal_type => animal_type

    breeds = Breed.auto_complete(animal_type.id, "Labrador").all

    breeds.count.should == 2
    breeds.should       =~ [breed1, breed2]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Breed, "#animal_type" do

  it "belongs to an animal type" do
    animal_type = AnimalType.new :name => "Dog"
    breed       = Breed.new :animal_type => animal_type

    breed.animal_type.should == animal_type
  end

  it "returns a readonly animal_type" do
    breed = Breed.gen
    breed.reload.animal_type.should be_readonly
  end
end

