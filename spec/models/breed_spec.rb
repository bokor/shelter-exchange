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

    expect(validation1.count).to eq(1)
    expect(validation2.count).to eq(0)
  end
end

describe Breed, ".auto_complete" do

  it "returns the correct breeds per animal type" do
    animal_type = AnimalType.gen

    breed1 = Breed.gen :name => "Labrador Retriever", :animal_type => animal_type
    breed2 = Breed.gen :name => "Labrador Husky", :animal_type => animal_type

    breeds = Breed.auto_complete(animal_type.id, "Labrador").all

    expect(breeds.count).to eq(2)
    expect(breeds).to match_array([breed1, breed2])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Breed, "#animal_type" do

  it "belongs to an animal type" do
    animal_type = AnimalType.new :name => "Dog"
    breed = Breed.new :animal_type => animal_type

    expect(breed.animal_type).to eq(animal_type)
  end

  it "returns a readonly animal_type" do
    breed = Breed.gen
    expect(breed.reload.animal_type).to be_readonly
  end
end

