require "spec_helper"

describe AnimalStatus do

  it "has a default scope" do
    expect(AnimalStatus.scoped.to_sql).to eq(AnimalStatus.order("animal_statuses.sort_order ASC").to_sql)
  end
end

# Constants
#----------------------------------------------------------------------------
describe AnimalStatus, "::STATUSES" do
  it "contains a default list of statuses" do
    expect(AnimalStatus::STATUSES).to eq({
      :available_for_adoption => 1,
      :adopted => 2,
      :foster_care => 3,
      :new_intake => 4,
      :in_transit => 5,
      :rescue_candidate => 6,
      :stray_intake => 7,
      :on_hold_behavioral => 8,
      :on_hold_medical => 9,
      :on_hold_bite => 10,
      :on_hold_custody => 11,
      :reclaimed => 12,
      :deceased => 13,
      :euthanized => 14,
      :transferred => 15,
      :adoption_pending => 16
    })
  end
end

describe AnimalStatus, "::CAPACITY" do
  it "contains a list of statuses for capacity counts" do
    expect(AnimalStatus::CAPACITY).to match_array([1,4,5,6,7,8,9,10,11,16])
  end
end

describe AnimalStatus, "::ACTIVE" do
  it "contains a list active statuses" do
    expect(AnimalStatus::ACTIVE).to match_array([1,3,4,5,6,7,8,9,10,11,16])
  end
end

describe AnimalStatus, "::NON_ACTIVE" do
  it "contains a list non active statuses" do
    expect(AnimalStatus::NON_ACTIVE).to match_array([2,12,13,14,15])
  end
end

describe AnimalStatus, "::AVAILABLE" do
  it "contains a list available statuses" do
    expect(AnimalStatus::AVAILABLE).to match_array([1,16])
  end
end

describe AnimalStatus, "::EXTRA_STATUS_FILTERS" do
  it "contains extra statuses for filter dropdowns" do
    expect(AnimalStatus::EXTRA_STATUS_FILTERS).to match_array([
      ["All Active", :active],
      ["All Non-Active", :non_active]
    ])
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe AnimalStatus, ".active" do

  it "returns only the active statuses" do
    AnimalStatus::ACTIVE.each do |status|
      AnimalStatus.gen! :id => status
    end
    expect(AnimalStatus.active.pluck(:id)).to match_array(AnimalStatus::ACTIVE)
  end
end

describe AnimalStatus, ".non_active" do

  it "returns only the non_active statuses" do
    AnimalStatus::NON_ACTIVE.each do |status|
      AnimalStatus.gen! :id => status
    end
    expect(AnimalStatus.non_active.pluck(:id)).to match_array(AnimalStatus::NON_ACTIVE)
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe AnimalStatus, "#animals" do

  before do
    @animal_status = AnimalStatus.gen
    @animal1 = Animal.gen :animal_status => @animal_status
    @animal2 = Animal.gen :animal_status => @animal_status
  end

  it "has many animals" do
    expect(@animal_status.animals.count).to eq(2)
    expect(@animal_status.animals).to match_array([@animal1, @animal2])
  end

  it "returns readonly animals" do
    expect(@animal_status.animals[0]).to be_readonly
    expect(@animal_status.animals[1]).to be_readonly
  end
end

describe AnimalStatus, "#status_histories" do

  before do
    @animal_status = AnimalStatus.gen
    @status_history1 = StatusHistory.gen :animal_status => @animal_status
    @status_history2 = StatusHistory.gen :animal_status => @animal_status
  end

  it "has many status histories" do
    expect(@animal_status.status_histories.count).to eq(2)
    expect(@animal_status.status_histories).to match_array([@status_history1, @status_history2])
  end

  it "destroys the status histories when a status is deleted" do
    expect(@animal_status.status_histories.count).to eq(2)
    @animal_status.destroy
    expect(@animal_status.status_histories.count).to eq(0)
  end
end

