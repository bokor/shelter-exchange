require "spec_helper"

# Constants
#----------------------------------------------------------------------------
describe AnimalType, "::TYPES" do
  it "should contain a default list of types" do
    AnimalType::TYPES.should == {
      :dog     => 1,
      :cat     => 2,
      :horse   => 3,
      :rabbit  => 4,
      :bird    => 5,
      :reptile => 6,
      :other   => 7
    }
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe AnimalType, "#animals" do

  it "should have many animals" do
    animal_type = AnimalType.gen

    animal1 = Animal.gen :animal_type => animal_type
    animal2 = Animal.gen :animal_type => animal_type

    animal_type.animals.count.should == 2
    animal_type.animals.should include(animal1, animal2)
  end
end

describe AnimalType, "#breeds" do

  it "should have many breeds" do
    animal_type = AnimalType.gen

    breed1 = Breed.gen :animal_type => animal_type
    breed2 = Breed.gen :animal_type => animal_type

    animal_type.breeds.count.should == 2
  end
end

describe AnimalType, "#accommodations" do

  it "should have many accommodations" do
    animal_type = AnimalType.gen

    accommodation1 = Accommodation.gen :animal_type => animal_type
    accommodation2 = Accommodation.gen :animal_type => animal_type

    animal_type.accommodations.count.should == 2
    animal_type.accommodations.should include(accommodation1, accommodation2)
  end
end

describe AnimalType, "#capacities" do

  it "should have many capacities" do
    animal_type = AnimalType.gen

    capacity1 = Capacity.gen :animal_type => animal_type
    capacity2 = Capacity.gen :animal_type => animal_type

    animal_type.capacities.count.should == 2
    animal_type.capacities.should include(capacity1, capacity2)
  end
end


