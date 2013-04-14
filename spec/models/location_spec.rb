require "spec_helper"

describe Location do

  it "should have a default scope" do
    Location.scoped.to_sql.should == Location.order('locations.name ASC').to_sql
  end

  it "should require presence of name" do
    location = Location.new :name => nil
    location.should have(1).error_on(:name)
    location.errors[:name].should == ["cannot be blank"]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Location, "#shelter" do

  it "should belong to a shelter" do
    shelter  = Shelter.new
    location = Location.new :shelter => shelter

    location.shelter.should == shelter
  end

  it "should return a readonly shelter" do
    location = Location.gen
    location.reload.shelter.should be_readonly
  end
end

describe Location, "#accommodations" do

  before do
    @location       = Location.gen
    @accommodation1 = Accommodation.gen :location => @location
    @accommodation2 = Accommodation.gen :location => @location
  end

  it "should have many accommodations" do
    @location.accommodations.count.should == 2
    @location.accommodations.should =~ [@accommodation1, @accommodation2]
  end

  it "should return a readonly accommodations" do
    @location.accommodations[0].should be_readonly
    @location.accommodations[1].should be_readonly
  end
end

