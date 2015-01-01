require "rails_helper"

describe Accommodation do

  it "has a default scope" do
    expect(Accommodation.scoped.to_sql).to eq(Accommodation.order("accommodations.name ASC").to_sql)
  end

  it "requires a animal type" do
    accommodation = Accommodation.new :animal_type_id => nil

    expect(accommodation.valid?).to be_falsey
    expect(accommodation.errors[:animal_type_id].size).to eq(1)
    expect(accommodation.errors[:animal_type_id]).to match_array(["needs to be selected"])
  end

  it "requires a name of the accommodation" do
    accommodation = Accommodation.new :name => nil

    expect(accommodation.valid?).to be_falsey
    expect(accommodation.errors[:name].size).to eq(1)
    expect(accommodation.errors[:name]).to match_array(["cannot be blank"])
  end

  it "validates a numerical value for max capacity" do
    accommodation = Accommodation.new :max_capacity => "abc"

    expect(accommodation.valid?).to be_falsey
    expect(accommodation.errors[:max_capacity].size).to eq(1)
    expect(accommodation.errors[:max_capacity]).to match_array(["requires a number"])
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Accommodation, ".per_page" do
  it "returns the per page value for pagination" do
    expect(Accommodation.per_page).to eq(50)
  end
end

describe Accommodation, ".search" do

  it "returns search results" do
    accommodation1 = Accommodation.gen :name => "Crate"
    Accommodation.gen :name => "Cage"

    results = Accommodation.search("Cra")
    expect(results.count).to eq(1)
    expect(results).to match_array([accommodation1])
  end
end

describe Accommodation, ".filter_by_type_location" do

  before do
    @dog = AnimalType.gen :name => "Dog"
    @cat = AnimalType.gen :name => "Cat"

    @west_side = Location.gen :name => "West Side"
    @east_side = Location.gen :name => "East Side"

    @accommodation1 = Accommodation.gen \
      :animal_type => @dog,
      :location => @west_side
    @accommodation2 = Accommodation.gen \
      :animal_type => @dog,
      :location => @west_side
    @accommodation3 = Accommodation.gen \
      :animal_type => @dog,
      :location => @east_side
  end

  it "filters by animal type" do
    results = Accommodation.filter_by_type_location(@dog, nil)
    expect(results.count).to eq(3)
    expect(results).to match_array([@accommodation1, @accommodation2, @accommodation3])
  end

  it "filters by location" do
    results = Accommodation.filter_by_type_location(nil, @west_side)
    expect(results.count).to eq(2)
    expect(results).to match_array([@accommodation1, @accommodation2])
  end

  it "filters by animal type and location" do
    results = Accommodation.filter_by_type_location(@dog, @east_side)
    expect(results.count).to eq(1)
    expect(results).to match_array([@accommodation3])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Accommodation, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    accommodation = Accommodation.new :shelter => shelter

    expect(accommodation.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    accommodation = Accommodation.gen
    expect(accommodation.reload.shelter).to be_readonly
  end
end

describe Accommodation, "#animal_type" do

  it "belongs to an animal type" do
    animal_type = AnimalType.gen
    accommodation = Accommodation.gen :animal_type => animal_type

    expect(accommodation.animal_type).to eq(animal_type)
  end

  it "returns a readonly animal type" do
    accommodation = Accommodation.gen
    expect(accommodation.reload.animal_type).to be_readonly
  end
end

describe Accommodation, "#location" do

  it "belongs to an location" do
    location = Location.new
    accommodation = Accommodation.new :location => location

    expect(accommodation.location).to eq(location)
  end

  it "returns a readonly location" do
    accommodation = Accommodation.gen
    expect(accommodation.reload.location).to be_readonly
  end
end

describe Accommodation, "#animals" do

  before do
    @accommodation = Accommodation.gen
    @animal1 = Animal.gen :accommodation => @accommodation
    @animal2 = Animal.gen :accommodation => @accommodation
  end

  it "returns a list of animals" do
    expect(@accommodation.animals.count).to eq(2)
    expect(@accommodation.animals).to match_array([@animal1, @animal2])
  end

  it "returns readonly animals" do
    expect(@accommodation.animals[0]).to be_readonly
    expect(@accommodation.animals[1]).to be_readonly
  end
end

