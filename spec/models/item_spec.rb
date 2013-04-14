require "spec_helper"

# Instance Methods
#----------------------------------------------------------------------------
describe Item, "#shelter" do

  it "should belong to a shelter" do
    shelter = Shelter.new
    item    = Item.new :shelter => shelter

    item.shelter.should == shelter
  end

  it "should return a readonly shelter" do
    item = Item.gen
    item.reload.shelter.should be_readonly
  end
end

