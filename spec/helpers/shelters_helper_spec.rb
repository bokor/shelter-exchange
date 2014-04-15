require "spec_helper"

describe SheltersHelper, "#setup_items" do

  it "returns empty shelter items" do
    shelter = Shelter.gen

    expect {
      helper.setup_items(shelter)
    }.to change(shelter.items, :size).by(5)
  end
end

