require "spec_helper"

describe Location do

  it "has a default scope" do
    expect(Location.scoped.to_sql).to eq(Location.order('locations.name ASC').to_sql)
  end

  it "requires presence of name" do
    location = Location.new :name => nil
    expect(location).to have(1).error_on(:name)
    expect(location.errors[:name]).to match_array(["cannot be blank"])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Location, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    location = Location.new :shelter => shelter

    expect(location.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    location = Location.gen
    expect(location.reload.shelter).to be_readonly
  end
end

describe Location, "#accommodations" do

  before do
    @location = Location.gen
    @accommodation1 = Accommodation.gen :location => @location
    @accommodation2 = Accommodation.gen :location => @location
  end

  it "has many accommodations" do
    expect(@location.accommodations.count).to eq(2)
    expect(@location.accommodations).to match_array([@accommodation1, @accommodation2])
  end

  it "returns a readonly accommodations" do
    expect(@location.accommodations[0]).to be_readonly
    expect(@location.accommodations[1]).to be_readonly
  end
end

