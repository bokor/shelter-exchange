require "spec_helper"


describe StatusHistory do

  it "has a default scope" do
    expect(StatusHistory.scoped.to_sql).to eq(StatusHistory.order('status_histories.status_date DESC, status_histories.created_at DESC').to_sql)
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe StatusHistory, ".create_with" do

  it "creates a status history" do
    expect(StatusHistory.count).to eq(0)

    status_history = StatusHistory.create_with(1, 2, 3, Date.today, "testing")

    expect(StatusHistory.count).to eq(1)

    expect(status_history.shelter_id).to eq(1)
    expect(status_history.animal_id).to eq(2)
    expect(status_history.animal_status_id).to eq(3)
    expect(status_history.status_date).to eq(Date.today)
    expect(status_history.reason).to eq("testing")
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

    @status_history1 = StatusHistory.gen :status_date => @date_for_status_history, :animal => animal, :animal_status_id => AnimalStatus::STATUSES[:available_for_adoption], :shelter => shelter1
    @status_history2 = StatusHistory.gen :status_date => @date_for_status_history - 1.day, :animal => animal, :animal_status_id => AnimalStatus::STATUSES[:adopted], :shelter => shelter1
    @status_history3 = StatusHistory.gen :status_date => @date_for_status_history - 1.day, :animal => animal, :animal_status_id => AnimalStatus::STATUSES[:adopted], :shelter => shelter2
    @status_history4 = StatusHistory.gen :status_date => @date_for_status_history + 1.month, :animal => animal, :animal_status_id => AnimalStatus::STATUSES[:available_for_adoption], :shelter => shelter2
  end

  describe StatusHistory, ".by_month" do

    it "returns status history ids and animal ids for a month range" do
      start_date = Date.civil(2013, 02, 01)
      range = start_date.beginning_of_month..start_date.end_of_month

      status_histories = StatusHistory.by_month(range)

      expect(status_histories.count).to eq(3)
      expect(status_histories).to match_array([@status_history1, @status_history2, @status_history3])
    end
  end

  describe StatusHistory, ".status_by_month_year" do

    it "returns the status histories for the month year" do
      status_histories = StatusHistory.status_by_month_year(02, 2013).all

      expect(status_histories.count).to eq(2)

      expect(status_histories[0].count).to eq(1)
      expect(status_histories[0].name).to eq("Available for adoption")

      expect(status_histories[1].count).to eq(2)
      expect(status_histories[1].name).to eq("Adopted")
    end

    it "returns the status histories for the month year and state" do
      status_histories = StatusHistory.status_by_month_year(02, 2013, "CA").all

      expect(status_histories.count).to eq(2)

      expect(status_histories[0].count).to eq(1)
      expect(status_histories[0].name).to eq("Available for adoption")

      expect(status_histories[1].count).to eq(1)
      expect(status_histories[1].name).to eq("Adopted")
    end
  end

  describe StatusHistory, ".totals_by_month" do

    it "returns the totals by month per status" do
      status_histories = StatusHistory.totals_by_month(2013, :adopted)

      expect(status_histories[0].type).to eq("Total")
      expect(status_histories[0].february).to eq(2)
    end

    it "returns the totals per type and status" do
      status_histories = StatusHistory.totals_by_month(2013, :available_for_adoption, true).all

      # Setting this because the Animal creates another Status history
      current_month = @date_for_status_history.strftime("%B").downcase
      next_month = (@date_for_status_history + 1.month).strftime("%B").downcase

      expect(status_histories[0].type).to eq("Dog")
      expect(status_histories[0].send(current_month)).to eq(1)
      expect(status_histories[0].send(next_month)).to eq(1)
    end
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe StatusHistory, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    status_history = StatusHistory.new :shelter => shelter

    expect(status_history.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    status_history = StatusHistory.gen
    expect(status_history.reload.shelter).to be_readonly
  end
end

describe StatusHistory, "#animal" do

  it "belongs to an animal" do
    animal = Animal.new
    status_history = StatusHistory.new :animal => animal

    expect(status_history.animal).to eq(animal)
  end

  it "returns a readonly animal" do
    status_history = StatusHistory.gen
    expect(status_history.reload.animal).to be_readonly
  end
end

describe StatusHistory, "#animal_status" do

  it "belongs to an animal status" do
    animal_status = AnimalStatus.new
    status_history = StatusHistory.new :animal_status => animal_status

    expect(status_history.animal_status).to eq(animal_status)
  end

  it "returns a readonly animal status" do
    status_history = StatusHistory.gen
    expect(status_history.reload.animal_status).to be_readonly
  end
end

describe StatusHistory, "#contact" do

  it "belongs to a contact" do
    contact = Contact.new
    status_history = StatusHistory.new :contact => contact

    expect(status_history.contact).to eq(contact)
  end

  it "returns a readonly contact" do
    status_history = StatusHistory.gen
    expect(status_history.reload.contact).to be_readonly
  end
end

