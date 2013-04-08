require "spec_helper"

describe Item, "#shelter" do

  it "should belong to a shelter" do
    shelter = Shelter.new
    item    = Item.new :shelter => shelter

    item.shelter.should == shelter
  end
end

