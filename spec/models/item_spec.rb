require "rails_helper"

# Instance Methods
#----------------------------------------------------------------------------
describe Item, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    item = Item.new :shelter => shelter

    expect(item.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    item = Item.gen
    expect(item.reload.shelter).to be_readonly
  end
end

