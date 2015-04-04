require "rails_helper"

describe AnimalStatus do

  it "has a default scope" do
    expect(AnimalStatus.scoped.to_sql).to eq(AnimalStatus.order("animal_statuses.sort_order ASC").to_sql)
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

