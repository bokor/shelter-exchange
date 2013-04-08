require "spec_helper"

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
    results.map(&:class).should == [Animal, Alert, Alert, Animal, Animal, Task]
  end

  it "should only return a total of 20 of the recent (Tasks, Alerts, Animals)" do
    10.times{ Animal.gen :shelter => @shelter}
    10.times{ Task.gen :shelter => @shelter }
    10.times{ Alert.gen :shelter => @shelter }

    results = Activity.recent(@shelter)
    results.count.should == 20
    results.map(&:class).uniq.should == [Alert, Task]
    results.map(&:class).uniq.should_not == [Animal]
  end
end

