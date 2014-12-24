require "rails_helper"

# Constants
#----------------------------------------------------------------------------
describe Activity, "::LIMIT" do
  it "returns the limit of each activity" do
    expect(Activity::LIMIT).to eq(10)
  end
end

describe Activity, "::PAGE_TOTAL" do
  it "returns the number of total activities per page" do
    expect(Activity::PAGE_TOTAL).to eq(20)
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Activity, ".recent" do

  before do
    @shelter = Shelter.gen
  end

  it "returns the correct data sorted by updated_at (Tasks, Alerts, Animals)" do
    Task.gen :shelter => @shelter, :updated_at => Time.now - 4.days
    Animal.gen :shelter => @shelter, :updated_at => Time.now - 3.days
    Alert.gen :shelter => @shelter, :updated_at => Time.now - 2.days
    Task.gen :shelter => @shelter, :updated_at => Time.now - 2.days
    Animal.gen :shelter => @shelter, :updated_at => Time.now - 1.day

    results = Activity.recent(@shelter)
    expect(results.count).to eq(5)
    expect(results.collect(&:class).collect(&:name)).to match_array(["Animal", "Alert", "Task", "Animal", "Task"])
  end

  it "returns a total of 20 of the recent (Tasks, Alerts, Animals)" do
    8.times{ Animal.gen :shelter => @shelter }
    8.times{ Task.gen :shelter => @shelter }
    8.times{ Alert.gen :shelter => @shelter }

    results = Activity.recent(@shelter)
    expect(results.count).to eq(20)
  end
end

