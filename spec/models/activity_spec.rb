require "spec_helper"

# Constants
#----------------------------------------------------------------------------
describe Activity, "::LIMIT" do
  it "should return the limit of each activity" do
    Activity::LIMIT.should == 10
  end
end

describe Activity, "::PAGE_TOTAL" do
  it "should return the number of total activities per page" do
    Activity::PAGE_TOTAL.should == 20
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Activity, ".recent" do

  before do
    @shelter = Shelter.gen
  end

  it "should return the correct data sorted by updated_at (Tasks, Alerts, Animals)" do
    1.times{ Task.gen :shelter => @shelter }
    2.times{ Animal.gen :shelter => @shelter }
    2.times{ Alert.gen :shelter => @shelter }
    1.times{ Animal.gen :shelter => @shelter }

    results = Activity.recent(@shelter)
    results.count.should == 6
    results.collect(&:class).collect(&:name).should == ["Animal", "Animal", "Animal", "Task", "Alert", "Alert"]
  end

  it "should only return a total of 20 of the recent (Tasks, Alerts, Animals)" do
    8.times{ Animal.gen :shelter => @shelter }
    8.times{ Task.gen :shelter => @shelter }
    8.times{ Alert.gen :shelter => @shelter }

    results = Activity.recent(@shelter)
    results.count.should == 20
  end
end

