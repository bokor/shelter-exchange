require "spec_helper"

describe AnimalStatus do

  it "should have a default scope" do
    AnimalStatus.gen :sort_order => 1
    AnimalStatus.gen :sort_order => 16
    AnimalStatus.gen :sort_order => 3

    AnimalStatus.all.collect(&:id).should == [1, 3, 2]
    AnimalStatus.scoped.to_sql.should == AnimalStatus.order("animal_statuses.sort_order ASC").to_sql
  end
end

# Constants
#----------------------------------------------------------------------------
describe AnimalStatus, "::STATUSES" do
  it "should contain a default list of statuses" do
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
  EXTRA_STATUS_FILTERS = [
    ["All Active", :active],
    ["All Non-Active", :non_active]
  ].freeze

describe AnimalStatus, "::ACTIVE" do
  it "should contain a list active statuses" do
    AnimalStatus::ACTIVE.should == [1,3,4,5,6,7,8,9,10,11,16]
  end
end

describe AnimalStatus, "::NON_ACTIVE" do
  it "should contain a list non active statuses" do
    AnimalStatus::NON_ACTIVE.should == [2,12,13,14,15]
  end
end

describe AnimalStatus, "::AVAILABLE" do
  it "should contain a list available statuses" do
    AnimalStatus::AVAILABLE.should == [1,16]
  end
end

describe AnimalStatus, "::EXTRA_STATUS_FILTERS" do
  it "should contain extra statuses for filter dropdowns" do
    AnimalStatus::EXTRA_STATUS_FILTERS.should == [
      ["All Active", :active],
      ["All Non-Active", :non_active]
    ]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe AnimalStatus, "#animals" do

  it "should have many animals" do
    animal_status = AnimalStatus.gen

    animal1 = Animal.gen :animal_status => animal_status
    animal2 = Animal.gen :animal_status => animal_status

    animal_status.should respond_to(:animals)
    animal_status.animals.count.should == 2
    animal_status.animals.should include(animal1, animal2)
  end
end

describe AnimalStatus, "#status_histories" do

  it "should have many status histories" do
    animal_status = AnimalStatus.gen

    status_history1 = StatusHistory.gen :animal_status => animal_status
    status_history2 = StatusHistory.gen :animal_status => animal_status

    animal_status.should respond_to(:status_histories)
    animal_status.status_histories.count.should == 2
    animal_status.status_histories.should include(status_history1, status_history2)
  end

  it "should destroy the status histories when a status is deleted" do
    animal_status = AnimalStatus.gen

    StatusHistory.gen :animal_status => animal_status, :animal => nil

    StatusHistory.count.should == 1
    animal_status.destroy
    StatusHistory.count.should == 0
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe AnimalStatus, ".active" do

  it "should return only the active statuses" do
    (1..AnimalStatus::STATUSES.size).each{ AnimalStatus.gen }
    AnimalStatus.active.pluck(:id).sort.should == [1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 16]
  end
end

describe AnimalStatus, ".non_active" do

  it "should return only the non_active statuses" do
    (1..AnimalStatus::STATUSES.size).each{ AnimalStatus.gen }
    AnimalStatus.non_active.pluck(:id).sort.should == [2, 12, 13, 14, 15]
  end
end

