require "rails_helper"

# Constants
#----------------------------------------------------------------------------
describe AnimalType, "::TYPES" do
  it "contains a default list of types" do
    expect(AnimalType::TYPES).to eq({
      :dog => 1,
      :cat => 2,
      :horse => 3,
      :rabbit => 4,
      :bird => 5,
      :reptile => 6,
      :other => 7
    })
  end
end

# Class Methods
#----------------------------------------------------------------------------

# Instance Methods
#----------------------------------------------------------------------------
describe AnimalType, "#animals" do

  before do
    @animal_type = AnimalType.gen
    @animal1 = Animal.gen :animal_type => @animal_type
    @animal2 = Animal.gen :animal_type => @animal_type
  end

  it "returns a list of animals" do
    expect(@animal_type.animals.count).to eq(2)
    expect(@animal_type.animals).to match_array([@animal1, @animal2])
  end

  it "returns readonly animals" do
    expect(@animal_type.animals[0]).to be_readonly
    expect(@animal_type.animals[1]).to be_readonly
  end
end

describe AnimalType, "#breeds" do

  before do
    @animal_type = AnimalType.gen
    @breed1 = Breed.gen :animal_type => @animal_type
    @breed2 = Breed.gen :animal_type => @animal_type
  end

  it "returns a list of breeds" do
    expect(@animal_type.breeds.count).to eq(2)
    expect(@animal_type.breeds).to match_array([@breed1, @breed2])
  end

  it "returns readonly breeds" do
    expect(@animal_type.breeds[0]).to be_readonly
    expect(@animal_type.breeds[1]).to be_readonly
  end
end

describe AnimalType, "#accommodations" do

  before do
    @animal_type = AnimalType.gen
    @accommodation1 = Accommodation.gen :animal_type => @animal_type
    @accommodation2 = Accommodation.gen :animal_type => @animal_type
  end

  it "returns a list of accommodations" do
    expect(@animal_type.accommodations.count).to eq(2)
    expect(@animal_type.accommodations).to match_array([@accommodation1, @accommodation2])
  end

  it "returns readonly accommodations" do
    expect(@animal_type.accommodations[0]).to be_readonly
    expect(@animal_type.accommodations[1]).to be_readonly
  end
end

describe AnimalType, "#capacities" do

  before do
    @animal_type = AnimalType.gen
    @capacity1 = Capacity.gen :animal_type => @animal_type
    @capacity2 = Capacity.gen :animal_type => @animal_type
  end

  it "returns a list of capacities" do
    expect(@animal_type.capacities.count).to eq(2)
    expect(@animal_type.capacities).to match_array([@capacity1, @capacity2])
  end

  it "returns readonly capacities" do
    expect(@animal_type.capacities[0]).to be_readonly
    expect(@animal_type.capacities[1]).to be_readonly
  end
end

