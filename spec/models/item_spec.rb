require "spec_helper"

describe Item, "#shelter" do

  it "should belong to a shelter" do
    shelter = Shelter.new
    item    = Item.new :shelter => shelter

    item.shelter.should == shelter
    item.shelter.should be_instance_of(Shelter)
  end
end

