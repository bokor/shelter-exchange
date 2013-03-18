require "spec_helper"

describe Item, "#shelter" do

  it "should belong to a shelter" do
    shelter = Shelter.gen
    item    = Item.gen :shelter => shelter

    item.shelter.should == shelter
    item.shelter.should be_instance_of(Shelter)
  end
end

