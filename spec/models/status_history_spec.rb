require "spec_helper"


describe StatusHistory do

  it "has a default scope" do
    StatusHistory.scoped.to_sql.should == StatusHistory.order('status_histories.created_at DESC').to_sql
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe StatusHistory, ".create_with" do

  it "creates a status history" do
    StatusHistory.count.should == 0

    status_history = StatusHistory.create_with(1, 2, 3, "testing")

    StatusHistory.count.should == 1

    status_history.shelter_id.should == 1
    status_history.animal_id.should == 2
    status_history.animal_status_id.should == 3
    status_history.reason.should == "testing"
  end
end

describe "Reports" do

  before do
    shelter1 = Shelter.gen :state => "CA"
    shelter2 = Shelter.gen :state => "NC"

    animal_type = AnimalType.gen :name => "Dog"

    AnimalStatus.destroy_all
    status1 = AnimalStatus.gen :id => AnimalStatus::STATUSES[:available_for_adoption], :name => "Available for adoption"
    AnimalStatus.gen :id => AnimalStatus::STATUSES[:adopted], :name => "Adopted"

    animal = Animal.gen :animal_type => animal_type, :animal_status => status1

    @date_for_status_history = Date.civil(2013, 02, 05)

    @status_history1 = StatusHistory.gen :created_at => @date_for_status_history, :animal => animal, :animal_status_id => AnimalStatus::STATUSES[:available_for_adoption], :shelter => shelter1
    @status_history2 = StatusHistory.gen :created_at => @date_for_status_history - 1.day, :animal => animal, :animal_status_id => AnimalStatus::STATUSES[:adopted], :shelter => shelter1
    @status_history3 = StatusHistory.gen :created_at => @date_for_status_history - 1.day, :animal => animal, :animal_status_id => AnimalStatus::STATUSES[:adopted], :shelter => shelter2
    @status_history4 = StatusHistory.gen :created_at => @date_for_status_history + 1.month, :animal => animal, :animal_status_id => AnimalStatus::STATUSES[:available_for_adoption], :shelter => shelter2
  end

  describe StatusHistory, ".by_month" do

    it "returns status history ids and animal ids for a month range" do
      start_date = Date.civil(2013, 02, 01)
      range = start_date.beginning_of_month..start_date.end_of_month

      status_histories = StatusHistory.by_month(range)

      status_histories.count.should == 3
      status_histories.should match_array([@status_history1.id, @status_history2.id, @status_history3.id])
    end
  end

  describe StatusHistory, ".status_by_month_year" do

    it "returns the status histories for the month year" do
      status_histories = StatusHistory.status_by_month_year(02, 2013).all

      status_histories.count.should == 2

      status_histories[0].count.should == 1
      status_histories[0].name.should == "Available for adoption"

      status_histories[1].count.should == 2
      status_histories[1].name.should == "Adopted"
    end

    it "returns the status histories for the month year and state" do
      status_histories = StatusHistory.status_by_month_year(02, 2013, "CA").all

      status_histories.count.should == 2

      status_histories[0].count.should == 1
      status_histories[0].name.should == "Available for adoption"

      status_histories[1].count.should == 1
      status_histories[1].name.should == "Adopted"
    end
  end

  describe StatusHistory, ".totals_by_month" do

    it "returns the totals by month per status" do
      status_histories = StatusHistory.totals_by_month(2013, :adopted)

      status_histories[0].type.should == "Total"
      status_histories[0].february.should == 2
    end

    it "returns the totals per type and status" do
      status_histories = StatusHistory.totals_by_month(2013, :available_for_adoption, true).all

      # Setting this because the Animal creates another Status history
      current_month = @date_for_status_history.strftime("%B").downcase
      next_month = (@date_for_status_history + 1.month).strftime("%B").downcase

      status_histories[0].type.should == "Dog"
      status_histories[0].send(current_month).should == 1
      status_histories[0].send(next_month).should == 1
    end
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe StatusHistory, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    status_history = StatusHistory.new :shelter => shelter

    status_history.shelter.should == shelter
  end

  it "returns a readonly shelter" do
    status_history = StatusHistory.gen
    status_history.reload.shelter.should be_readonly
  end
end

describe StatusHistory, "#animal" do

  it "belongs to an animal" do
    animal = Animal.new
    status_history = StatusHistory.new :animal => animal

    status_history.animal.should == animal
  end

  it "returns a readonly animal" do
    status_history = StatusHistory.gen
    status_history.reload.animal.should be_readonly
  end
end

describe StatusHistory, "#animal_status" do

  it "belongs to an animal status" do
    animal_status = AnimalStatus.new
    status_history = StatusHistory.new :animal_status => animal_status

    status_history.animal_status.should == animal_status
  end

  it "returns a readonly animal status" do
    status_history = StatusHistory.gen
    status_history.reload.animal_status.should be_readonly
  end
end

