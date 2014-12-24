require "rails_helper"

describe Capacity do

  it "requires presence of animal type id" do
    capacity = Capacity.new :animal_type_id => nil

    expect(capacity.valid?).to be_falsey
    expect(capacity.errors[:animal_type_id].size).to eq(1)
    expect(capacity.errors[:animal_type_id]).to match_array(["needs to be selected"])
  end

  it "requires uniqueness scoped by shelter id of animal type id" do
    shelter     = Shelter.new
    animal_type = AnimalType.gen
    capacity1   = Capacity.gen :animal_type => animal_type, :shelter => shelter
    capacity2   = Capacity.gen :animal_type => animal_type, :shelter => shelter

    expect(capacity1.errors.size).to eq(0)

    expect(capacity2.valid?).to be_falsey
    expect(capacity2.errors[:animal_type_id].size).to eq(1)
    expect(capacity2.errors[:animal_type_id]).to match_array(["is already in use"])
  end

  it "requires a number for max capacity" do
    capacity = Capacity.new :max_capacity => "abc"

    expect(capacity.valid?).to be_falsey
    expect(capacity.errors[:max_capacity].size).to eq(1)
    expect(capacity.errors[:max_capacity]).to match_array(["requires a number"])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Capacity, "#shelter" do

  it "belongs to a shelter" do
    shelter  = Shelter.new
    capacity = Capacity.new :shelter => shelter

    expect(capacity.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    capacity = Capacity.gen
    expect(capacity.reload.shelter).to be_readonly
  end
end

describe Capacity, "#animal_type" do

  it "belongs to a animal type" do
    animal_type = AnimalType.new
    capacity = Capacity.new :animal_type => animal_type

    expect(capacity.animal_type).to eq(animal_type)
  end

  it "returns a readonly animal type" do
    capacity = Capacity.gen
    expect(capacity.reload.animal_type).to be_readonly
  end
end

describe Capacity, "#animal_count" do
  it "returns a count of the active animals per animal type" do
    shelter = Shelter.gen
    animal_type = AnimalType.gen
    capacity = Capacity.gen :animal_type => animal_type, :shelter => shelter

    AnimalStatus::STATUSES.values.each do |status|
      Animal.gen :animal_type => animal_type, :shelter => shelter, :animal_status_id => status
    end

    count = capacity.animal_count(shelter)
    expect(count).to eq(AnimalStatus::CAPACITY.count)
  end
end

