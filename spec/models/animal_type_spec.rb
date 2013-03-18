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

  it "should return a list of animals" do
    animal_type = AnimalType.find(1)

    Animal.gen :animal_type => animal_type
    Animal.gen :animal_type => animal_type

    animal_type.should respond_to(:animals)
    animal_type.animals.count.should == 2
  end
end

describe AnimalType, "#breeds" do

  it "should return a list of breeds" do
    animal_type = AnimalType.find(1)

    animal_type.should respond_to(:breeds)
    animal_type.breeds.count.should == 263
  end
end

describe AnimalType, "#accommodations" do

  it "should return a list of accommodations" do
    animal_type = AnimalType.find(1)

    Accommodation.gen :animal_type => animal_type
    Accommodation.gen :animal_type => animal_type

    animal_type.should respond_to(:accommodations)
    animal_type.accommodations.count.should == 2
  end
end

describe AnimalType, "#capacities" do

  it "should return a list of capacities" do
    animal_type = AnimalType.find(1)

    Capacity.gen :animal_type => animal_type
    Capacity.gen :animal_type => animal_type

    animal_type.should respond_to(:capacities)
    animal_type.capacities.count.should == 2
  end
end


