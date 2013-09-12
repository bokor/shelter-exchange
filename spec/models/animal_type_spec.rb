require "spec_helper"

# Constants
#----------------------------------------------------------------------------
describe AnimalType, "::TYPES" do
  it "contains a default list of types" do
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

# Class Methods
#----------------------------------------------------------------------------

# Instance Methods
#----------------------------------------------------------------------------
describe AnimalType, "#animals" do

  before do
    @animal_type = AnimalType.gen
    @animal1     = Animal.gen :animal_type => @animal_type
    @animal2     = Animal.gen :animal_type => @animal_type
  end

  it "returns a list of animals" do
    @animal_type.animals.count.should == 2
    @animal_type.animals.should =~ [@animal1, @animal2]
  end

  it "returns readonly animals" do
    @animal_type.animals[0].should be_readonly
    @animal_type.animals[1].should be_readonly
  end
end

describe AnimalType, "#breeds" do

  before do
    @animal_type = AnimalType.gen
    @breed1      = Breed.gen :animal_type => @animal_type
    @breed2      = Breed.gen :animal_type => @animal_type
  end

  it "returns a list of breeds" do
    @animal_type.breeds.count.should == 2
    @animal_type.breeds.should =~ [@breed1, @breed2]
  end

  it "returns readonly breeds" do
    @animal_type.breeds[0].should be_readonly
    @animal_type.breeds[1].should be_readonly
  end
end

describe AnimalType, "#accommodations" do

  before do
    @animal_type    = AnimalType.gen
    @accommodation1 = Accommodation.gen :animal_type => @animal_type
    @accommodation2 = Accommodation.gen :animal_type => @animal_type
  end

  it "returns a list of accommodations" do
    @animal_type.accommodations.count.should == 2
    @animal_type.accommodations.should =~ [@accommodation1, @accommodation2]
  end

  it "returns readonly accommodations" do
    @animal_type.accommodations[0].should be_readonly
    @animal_type.accommodations[1].should be_readonly
  end
end

describe AnimalType, "#capacities" do

  before do
    @animal_type = AnimalType.gen
    @capacity1   = Capacity.gen :animal_type => @animal_type
    @capacity2   = Capacity.gen :animal_type => @animal_type
  end

  it "returns a list of capacities" do
    @animal_type.capacities.count.should == 2
    @animal_type.capacities.should =~ [@capacity1, @capacity2]
  end

  it "returns readonly capacities" do
    @animal_type.capacities[0].should be_readonly
    @animal_type.capacities[1].should be_readonly
  end
end

