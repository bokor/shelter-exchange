require "rails_helper"

# Class Methods
#----------------------------------------------------------------------------
describe Activity, ".recent" do

  before do
    @shelter = Shelter.gen
  end

  it "returns the correct data sorted by updated_at (Tasks, Animals)" do
    Task.gen :shelter => @shelter, :updated_at => Time.now - 4.days
    Animal.gen :shelter => @shelter, :updated_at => Time.now - 3.days
    Task.gen :shelter => @shelter, :updated_at => Time.now - 2.days
    Animal.gen :shelter => @shelter, :updated_at => Time.now - 1.day

    results = Activity.recent(@shelter)
    expect(results.count).to eq(4)
    expect(results.collect(&:class).collect(&:name)).to match_array(["Animal", "Task", "Animal", "Task"])
  end

  it "returns a total of 20 of the recent (Tasks, Animals)" do
    8.times{ Animal.gen :shelter => @shelter }
    8.times{ Task.gen :shelter => @shelter }

    results = Activity.recent(@shelter)
    expect(results.count).to eq(16)
  end
end

