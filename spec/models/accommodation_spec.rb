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

describe Accommodation, ".search_and_filter" do

  it "returns all accommodations when no params" do
    accommodation1 = Accommodation.gen
    accommodation2 = Accommodation.gen

    accommodations = Accommodation.search_and_filter(nil, nil, nil, nil)

    expect(accommodations.count).to eq(2)
    expect(accommodations).to match_array([accommodation1, accommodation2])
  end

  context "with alphanumeric search term" do

    it "searches for accommodations like the name" do
      accommodation1 = Accommodation.gen :name => "DoggieTown"
      accommodation2 = Accommodation.gen :name => "DogTown"
      Accommodation.gen :name => "KittyTown"

      accommodations = Accommodation.search_and_filter("dog", nil, nil, nil)

      expect(accommodations.count).to eq(2)
      expect(accommodations).to match_array([accommodation1, accommodation2])
    end
  end

  context "with animal type" do

    it "filters animals with specific type" do
      accommodation1 = Accommodation.gen :name => "DoggieTown", :animal_type_id => 1
      accommodation2 = Accommodation.gen :name => "DogTown", :animal_type_id => 1
      Accommodation.gen :name => "KittyTown", :animal_type_id => 2

      accommodations = Accommodation.search_and_filter(nil, "1", nil, nil)

      expect(accommodations.count).to eq(2)
      expect(accommodations).to match_array([accommodation1, accommodation2])
    end
  end

  context "with location" do

    it "filters animals with specific location" do
      location = Location.gen
      accommodation1 = Accommodation.gen :name => "DoggieTown", :location => location
      accommodation2 = Accommodation.gen :name => "DogTown", :location => location
      Accommodation.gen :name => "KittyTown", :location => Location.gen

      accommodations = Accommodation.search_and_filter(nil, nil, location.id, nil)

      expect(accommodations.count).to eq(2)
      expect(accommodations).to match_array([accommodation1, accommodation2])
    end
  end

  context "with order by" do

    it "Sorts the animals with the order by param" do
      accommodation1 = Accommodation.gen :name => "Orange"
      accommodation2 = Accommodation.gen :name => "Apple"
      accommodation3 = Accommodation.gen :name => "Lettuce"

      accommodations = Accommodation.search_and_filter(nil, nil, nil, "accommodations.name ASC")

      expect(accommodations.count).to eq(3)
      expect(accommodations).to eq([accommodation2, accommodation3, accommodation1])
    end
  end

  context "with multiple search and filter criteria" do

    it "filters animals with specific type and status" do
      location = Location.gen
      accommodation1 = Accommodation.gen :name => "DoggieTown", :animal_type_id => 1, :location => location
      Accommodation.gen :name => "DogTown", :animal_type_id => 2, :location => location
      Accommodation.gen :name => "KittyTown", :animal_type_id => 1

      accommodations = Accommodation.search_and_filter(nil, "1", location.id, nil)

      expect(accommodations.count).to eq(1)
      expect(accommodations).to match_array([accommodation1])
    end
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

