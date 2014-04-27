require "spec_helper"

describe CapacitiesHelper, "#capacity_status" do

  before do
    @capacity = Capacity.gen :max_capacity => 10
  end

  it "returns text red" do
    expect(
      helper.capacity_status(@capacity, 8)
    ).to eq("red")
  end

  it "returns text yellow" do
    expect(
      helper.capacity_status(@capacity, 6)
    ).to eq("yellow")
  end

  it "returns text green" do
    expect(
      helper.capacity_status(@capacity, 4)
    ).to eq("green")
  end
end

