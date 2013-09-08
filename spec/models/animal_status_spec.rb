require "spec_helper"

describe AnimalStatus do

  it "has a default scope" do
    AnimalStatus.scoped.to_sql.should  == AnimalStatus.order("animal_statuses.sort_order ASC").to_sql
  end
end

# Constants
#----------------------------------------------------------------------------
describe AnimalStatus, "::STATUSES" do
  it "contains a default list of statuses" do
    AnimalStatus::STATUSES.should == {
      :available_for_adoption => 1,
      :adopted                => 2,
      :foster_care            => 3,
      :new_intake             => 4,
      :in_transit             => 5,
      :rescue_candidate       => 6,
      :stray_intake           => 7,
      :on_hold_behavioral     => 8,
      :on_hold_medical        => 9,
      :on_hold_bite           => 10,
      :on_hold_custody        => 11,
      :reclaimed              => 12,
      :deceased               => 13,
      :euthanized             => 14,
      :transferred            => 15,
      :adoption_pending       => 16
    }
  end
end

describe AnimalStatus, "::CAPACITY" do
  it "contains a list of statuses for capacity counts" do
    AnimalStatus::CAPACITY.should == [1,4,5,6,7,8,9,10,11,16]
  end
end

describe AnimalStatus, "::ACTIVE" do
  it "contains a list active statuses" do
    AnimalStatus::ACTIVE.should == [1,3,4,5,6,7,8,9,10,11,16]
  end
end

describe AnimalStatus, "::NON_ACTIVE" do
  it "contains a list non active statuses" do
    AnimalStatus::NON_ACTIVE.should == [2,12,13,14,15]
  end
end

describe AnimalStatus, "::AVAILABLE" do
  it "contains a list available statuses" do
    AnimalStatus::AVAILABLE.should == [1,16]
  end
end

describe AnimalStatus, "::EXTRA_STATUS_FILTERS" do
  it "contains extra statuses for filter dropdowns" do
    AnimalStatus::EXTRA_STATUS_FILTERS.should == [
      ["All Active", :active],
      ["All Non-Active", :non_active]
    ]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe AnimalStatus, "#animals" do

  before do
    @animal_status = AnimalStatus.gen
    @animal1       = Animal.gen :animal_status => @animal_status
    @animal2       = Animal.gen :animal_status => @animal_status
  end

  it "has many animals" do
    @animal_status.animals.count.should == 2
    @animal_status.animals.should =~ [@animal1, @animal2]
  end

  it "returns readonly animals" do
    @animal_status.animals[0].should be_readonly
    @animal_status.animals[1].should be_readonly
  end
end

describe AnimalStatus, "#status_histories" do

  before do
    @animal_status   = AnimalStatus.gen
    @status_history1 = StatusHistory.gen :animal_status => @animal_status
    @status_history2 = StatusHistory.gen :animal_status => @animal_status
  end

  it "has many status histories" do
    @animal_status.status_histories.count.should == 2
    @animal_status.status_histories.should       =~ [@status_history1, @status_history2]
  end

  it "destroys the status histories when a status is deleted" do
    @animal_status.status_histories.count.should == 2
    @animal_status.destroy
    @animal_status.status_histories.count.should == 0
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe AnimalStatus, ".active" do

  it "returns only the active statuses" do
    AnimalStatus::ACTIVE.each do |status|
      AnimalStatus.gen! :id => status
    end
    AnimalStatus.active.pluck(:id).should =~ AnimalStatus::ACTIVE
  end
end

describe AnimalStatus, ".non_active" do

  it "returns only the non_active statuses" do
    AnimalStatus::NON_ACTIVE.each do |status|
      AnimalStatus.gen! :id => status
    end
    AnimalStatus.non_active.pluck(:id).should =~ AnimalStatus::NON_ACTIVE
  end
end

