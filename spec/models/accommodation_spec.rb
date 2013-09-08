require "spec_helper"

describe Accommodation do

  it "has a default scope" do
    Accommodation.scoped.to_sql.should == Accommodation.order("accommodations.name ASC").to_sql
  end

  it "requires a animal type" do
    accommodation = Accommodation.new :animal_type_id => nil
    accommodation.should have(1).error_on(:animal_type_id)
    accommodation.errors[:animal_type_id].should == ["needs to be selected"]
  end

  it "requires a name of the accommodation" do
    accommodation = Accommodation.new :name => nil
    accommodation.should have(1).error_on(:name)
    accommodation.errors[:name].should == ["cannot be blank"]
  end

  it "validates a numerical value for max capacity" do
    accommodation = Accommodation.new :max_capacity => "abc"
    accommodation.should have(1).error_on(:max_capacity)
    accommodation.errors[:max_capacity].should == ["requires a number"]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Accommodation, "#shelter" do

  it "belongs to a shelter" do
    shelter       = Shelter.new
    accommodation = Accommodation.new :shelter => shelter

    accommodation.shelter.should == shelter
  end

  it "returns a readonly shelter" do
    accommodation = Accommodation.gen
    accommodation.reload.shelter.should be_readonly
  end
end

describe Accommodation, "#animal_type" do

  it "belongs to an animal type" do
    animal_type   = AnimalType.gen
    accommodation = Accommodation.gen :animal_type => animal_type

    accommodation.animal_type.should == animal_type
  end

  it "returns a readonly animal type" do
    accommodation = Accommodation.gen
    accommodation.reload.animal_type.should be_readonly
  end
end

describe Accommodation, "#location" do

  it "belongs to an location" do
    location      = Location.new
    accommodation = Accommodation.new :location => location

    accommodation.location.should == location
  end

  it "returns a readonly location" do
    accommodation = Accommodation.gen
    accommodation.reload.location.should be_readonly
  end
end

describe Accommodation, "#animals" do

  before do
    @accommodation = Accommodation.gen
    @animal1 = Animal.gen :accommodation => @accommodation
    @animal2 = Animal.gen :accommodation => @accommodation
  end

  it "returns a list of animals" do
    @accommodation.animals.count.should == 2
    @accommodation.animals.should =~ [@animal1, @animal2]
  end

  it "returns readonly animals" do
    @accommodation.animals[0].should be_readonly
    @accommodation.animals[1].should be_readonly
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Accommodation, ".per_page" do
  it "returns the per page value for pagination" do
    Accommodation.per_page.should == 50
  end
end

describe Accommodation, ".search" do

  it "returns search results" do
    accommodation1 = Accommodation.gen :name => "Crate"
    accommodation2 = Accommodation.gen :name => "Cage"

    results = Accommodation.search("Cra")
    results.count.should == 1
    results.should =~ [accommodation1]
  end
end

describe Accommodation, ".filter_by_type_location" do

  before do
    @dog   = AnimalType.gen :name => "Dog"
    @cat   = AnimalType.gen :name => "Cat"

    @west_side      = Location.gen :name => "West Side"
    @east_side      = Location.gen :name => "East Side"

    @accommodation1 = Accommodation.gen \
      :animal_type => @dog,
      :location    => @west_side
    @accommodation2 = Accommodation.gen \
      :animal_type => @dog,
      :location    => @west_side
    @accommodation3 = Accommodation.gen \
      :animal_type => @dog,
      :location    => @east_side
  end

  it "filters by animal type" do
    results = Accommodation.filter_by_type_location(@dog, nil)
    results.count.should == 3
    results.should =~ [@accommodation1, @accommodation2, @accommodation3]
  end

  it "filters by location" do
    results = Accommodation.filter_by_type_location(nil, @west_side)
    results.count.should == 2
    results.should =~ [@accommodation1, @accommodation2]
  end

  it "filters by animal type and location" do
    results = Accommodation.filter_by_type_location(@dog, @east_side)
    results.count.should == 1
    results.should =~ [@accommodation3]
  end
end

