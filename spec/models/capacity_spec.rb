require "spec_helper"

describe Capacity do

  it "requires presence of animal type id" do
    capacity = Capacity.new :animal_type_id => nil
    capacity.should have(1).error_on(:animal_type_id)
    capacity.errors[:animal_type_id].should == ["needs to be selected"]
  end

  it "requires uniqueness scoped by shelter id of animal type id" do
    shelter     = Shelter.new
    animal_type = AnimalType.gen
    capacity1   = Capacity.gen :animal_type => animal_type, :shelter => shelter
    capacity2   = Capacity.gen :animal_type => animal_type, :shelter => shelter

    capacity1.should have(0).errors

    capacity2.should have(1).error_on(:animal_type_id)
    capacity2.errors[:animal_type_id].should == ["is already in use"]
  end

  it "requires a number for max capacity" do
    capacity = Capacity.new :max_capacity => "abc"
    capacity.should have(1).error_on(:max_capacity)
    capacity.errors[:max_capacity].should == ["requires a number"]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Capacity, "#shelter" do

  it "belongs to a shelter" do
    shelter  = Shelter.new
    capacity = Capacity.new :shelter => shelter

    capacity.shelter.should == shelter
  end

  it "returns a readonly shelter" do
    capacity = Capacity.gen
    capacity.reload.shelter.should be_readonly
  end
end

describe Capacity, "#animal_type" do

  it "belongs to a animal type" do
    animal_type = AnimalType.new
    capacity    = Capacity.new :animal_type => animal_type

    capacity.animal_type.should == animal_type
  end

  it "returns a readonly animal type" do
    capacity = Capacity.gen
    capacity.reload.animal_type.should be_readonly
  end
end

describe Capacity, "#animal_count" do
  it "returns a count of the active animals per animal type" do
    shelter     = Shelter.gen
    animal_type = AnimalType.gen
    capacity    = Capacity.gen :animal_type => animal_type, :shelter => shelter

    AnimalStatus::STATUSES.values.each do |status|
      Animal.gen :animal_type => animal_type, :shelter => shelter, :animal_status_id => status
    end

    count = capacity.animal_count(shelter)
    count.should == AnimalStatus::CAPACITY.count
  end
end

