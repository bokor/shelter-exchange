require "spec_helper"

describe Animal do

  it_should_behave_like Statusable
  it_should_behave_like Typeable
  it_should_behave_like Uploadable

  it "has a default scope" do
    Animal.scoped.to_sql.should == Animal.order('animals.updated_at DESC').to_sql
  end

  it "validates presence of name" do
    animal = Animal.new :name => nil
    animal.should have(1).error_on(:name)
    animal.errors[:name].should == ["cannot be blank"]
  end

  it "validates presence of animal type id" do
    animal = Animal.new :animal_type_id => nil
    animal.should have(1).error_on(:animal_type_id)
    animal.errors[:animal_type_id].should == ["needs to be selected"]
  end

  it "validates presence of animal status id" do
    animal = Animal.new :animal_status_id => nil
    animal.should have(1).error_on(:animal_status_id)
    animal.errors[:animal_status_id].should == ["needs to be selected"]
  end

  it "validates breed of primary breed" do
    animal = Animal.gen :primary_breed => nil, :animal_type_id => 1
    animal.should have(1).error_on(:primary_breed)
    animal.errors[:primary_breed].should == ["cannot be blank"]

    animal = Animal.new :primary_breed => "aaa", :animal_type_id => 1
    animal.should have(1).error_on(:primary_breed)
    animal.errors[:primary_breed].should == ["must contain a valid breed name"]
  end

  it "validates breed of secondary breed" do
    animal = Animal.new :is_mix_breed => true, :secondary_breed => nil, :animal_type_id => 1
    animal.should have(0).error_on(:secondary_breed)

    animal = Animal.new :is_mix_breed => true, :secondary_breed => "aaa", :animal_type_id => 1
    animal.should have(1).error_on(:secondary_breed)
    animal.errors[:secondary_breed].should == ["must contain a valid breed name"]
  end

  it "validates presence of sex" do
    animal = Animal.new :sex => nil
    animal.should have(1).error_on(:sex)
    animal.errors[:sex].should == ["cannot be blank"]
  end

  it "validates presence of age if status is active" do
    animal = Animal.new :age => nil, :animal_status_id => 1
    animal.should have(1).error_on(:age)
    animal.errors[:age].should == ["needs to be selected"]

    animal = Animal.new :age => nil, :animal_status_id => 2
    animal.should have(0).error_on(:age)
  end

  it "validates presence of size if status is active" do
    animal = Animal.new :size => nil, :animal_status_id => 1
    animal.should have(1).error_on(:size)
    animal.errors[:size].should == ["needs to be selected"]

    animal = Animal.new :size => nil, :animal_status_id => 2
    animal.should have(0).error_on(:size)
  end

  it "validates uniqueness of microchip" do
    shelter = Shelter.gen
    Animal.gen :microchip => "microchip", :shelter => shelter

    animal = Animal.new :microchip => "microchip", :shelter => shelter
    animal.should have(1).error_on(:microchip)
    animal.errors[:microchip].should == [
      "already exists in your shelter. Please return to the main Animal page and search by this microchip number to locate this record."
    ]

    # Another Shelter
    animal = Animal.new :microchip => "microchip"
    animal.should have(0).error_on(:microchip)
  end

  it "validates allows blank for microchip" do
    animal = Animal.new :microchip => nil
    animal.should have(0).error_on(:microchip)
  end

  it "validates presence of special needs" do
    animal = Animal.new :has_special_needs => true
    animal.should have(1).error_on(:special_needs)
    animal.errors[:special_needs].should == ["cannot be blank"]
  end

  it "validates video url format of video url" do
    animal = Animal.new :video_url => "http://vimeo.com/1234"
    animal.should have(1).error_on(:video_url)
    animal.errors[:video_url].should == ["incorrect You Tube URL format"]
  end

  it "validates allows blank for video url" do
    animal = Animal.new :video_url => nil
    animal.should have(0).error_on(:video_url)
  end

  it "validates date format of date of birth before today" do
    today = Date.today + 1.month
    animal = Animal.gen(
      :date_of_birth_day => today.day,
      :date_of_birth_month => today.month,
      :date_of_birth_year => today.year
    )
    animal.should have(1).error_on(:date_of_birth)
    animal.errors[:date_of_birth].should == ["has to be before today's date"]
  end

  it "validates date format of date of birth invalid date" do
    today = Date.today
    animal = Animal.new(
      :date_of_birth_day => today.day,
      :date_of_birth_month => today.month,
      :date_of_birth_year => nil
    )
    animal.should have(1).error_on(:date_of_birth)
    animal.errors[:date_of_birth].should == ["is an invalid date format"]
  end

  it "validates date format of arrival date invalid date" do
    today = Date.today
    animal = Animal.new(
      :arrival_date_day => today.day,
      :arrival_date_month => today.month,
      :arrival_date_year => nil
    )
    animal.should have(1).error_on(:arrival_date)
    animal.errors[:arrival_date].should == ["is an invalid date format"]
  end

  it "validates date format of euthanasia date invalid date" do
    today = Date.today
    animal = Animal.new(
      :euthanasia_date_day => today.day,
      :euthanasia_date_month => today.month,
      :euthanasia_date_year => nil
    )
    animal.should have(1).error_on(:euthanasia_date)
    animal.errors[:euthanasia_date].should == ["is an invalid date format"]
  end

  context "Nested Attributes" do

    before do
      @image = File.open("#{Rails.root}/spec/data/images/photo.jpg")
    end

    it "accepts nested attributes for photos" do
      Animal.count.should == 0
      Photo.count.should   == 0

      Animal.gen :photos_attributes => [{:image => @image}]

      Photo.count.should == 1
      Photo.count.should   == 1
    end

    it "rejects nested attributes for photos" do
      Animal.count.should == 0
      Photo.count.should   == 0

      Animal.gen :photos_attributes => [{:image => nil}]

      Animal.count.should == 1
      Photo.count.should   == 0
    end

    it "destroys nested photos" do
      animal = Animal.gen :photos_attributes => [{:image => @image}]

      Animal.count.should == 1
      Photo.count.should   == 1

      animal.destroy

      Animal.count.should == 0
      Photo.count.should   == 0
    end
  end

  context "Before Save" do

    it "cleans the description to remove all of the MS formatting" do
      animal = Animal.gen(
        :description => "\u2036\u201F\u2035\u2032\u2013\u02C6\u2039\u203A\u2013\u2014\u2026\u00A9\u00AE\u2122\u00BC\u00BD\u00BE\u02DC"
      )
      animal.description.should == "\"\"''-^<>--...&copy;&reg;&trade;&frac14;&frac12;&frac34;"
    end

    it "strips the description" do
      animal = Animal.gen(
        :description => "   hi    "
      )
      animal.description.should == "hi"
    end

    it "removed secondary breed when the mixed breed is false" do
      animal = Animal.gen(
        :secondary_breed => "test",
        :is_mix_breed => false
      )
      animal.secondary_breed.should be_nil
    end

    it "removed special needs when the has special needs is false" do
      animal = Animal.gen(
        :special_needs => "test",
        :has_special_needs => false
      )
      animal.special_needs.should be_nil
    end

    it "changes the status date for a new record" do
      animal = Animal.gen
      animal.status_change_date.should == Date.today
    end

    it "changes the status date when the animal status changes" do
      animal = Animal.gen :animal_status_id => 1
      animal.update_attributes(:status_change_date => Date.today - 1.month)

      animal.status_change_date.should == Date.today - 1.month

      animal.update_attributes(:animal_status_id => 2)

      animal.status_change_date.should == Date.today
    end
  end

  context "After Validation" do

    it "updates the breed names to exactly match the ones in the database" do
      primary_breed = Breed.gen(:name => "Labrador Retriever")
      secondary_breed = Breed.gen(:name => "Border Collie")

      animal = Animal.gen(
        :primary_breed => " labrador retriever    ",
        :secondary_breed => " border collie  "
      )

      animal.primary_breed.should == "Labrador Retriever"
      animal.secondary_breed.should == "Border Collie"
    end
  end

  context "After Save" do

    it "creates status history for a new record" do
      Animal.count.should == 0
      StatusHistory.count.should == 0

      animal = Animal.gen

      Animal.count.should == 1
      StatusHistory.count.should == 1
    end

    it "creates status history when the animal status has changed" do
      Animal.count.should == 0
      StatusHistory.count.should == 0

      animal = Animal.gen :status_history_reason => "New Record"

      Animal.count.should == 1
      StatusHistory.count.should == 1

      animal.animal_status = AnimalStatus.gen
      animal.status_history_reason = "Status Updated"
      animal.save

      Animal.count.should == 1
      StatusHistory.count.should == 2

      histories = StatusHistory.all
      histories.map(&:reason).should == ["New Record", "Status Updated"]
    end

    it "creates status history when the shelter has changed" do
      Animal.count.should == 0
      StatusHistory.count.should == 0

      animal = Animal.gen :status_history_reason => "New Record"

      Animal.count.should == 1
      StatusHistory.count.should == 1

      shelter = Shelter.gen
      animal.shelter = shelter
      animal.status_history_reason = "New Transfer"
      animal.save

      Animal.count.should == 1
      StatusHistory.count.should == 2

      histories = StatusHistory.all
      histories[0].reason.should == "New Record"
      histories[1].reason.should == "New Transfer"
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe Animal, "::SEX" do
  it "contains a default list of genders" do
    Animal::SEX.should == ["male", "female"]
  end
end

describe Animal, "::AGES" do
  it "contains a default list of ages" do
    Animal::AGES.should == ["baby", "young", "adult", "senior"]
  end
end

describe Animal, "::SIZES" do
  it "contains a default list of sizes" do
    Animal::SIZES.should == {
      :S => "Small",
      :M => "Medium",
      :L => "Large",
      :XL => "X-Large"
    }
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Animal, ".latest" do

  it "returns the latest animals for a specific status and limit" do
    animal1 = Animal.gen(:animal_status_id => 1)
    animal2 = Animal.gen(:animal_status_id => 1)
    animal3 = Animal.gen(:animal_status_id => 1)
    animal4 = Animal.gen(:animal_status_id => 2)

    animal1.update_attribute(:status_change_date, Date.today)
    animal2.update_attribute(:status_change_date, Date.today - 2.days)
    animal3.update_attribute(:status_change_date, Date.today - 1.days)

    animals = Animal.latest(:available_for_adoption, 4)

    animals.count.should == 3
    animals.should =~ [animal1, animal3, animal2]
  end
end

describe Animal, ".auto_complete" do

  it "returns the animals like the name parameter" do
    animal1 = Animal.gen(:name => "Doggie")
    animal2 = Animal.gen(:name => "Dog")
    animal3 = Animal.gen(:name => "Cat")

    animals = Animal.auto_complete("dog")

    animals.count.should == 2
    animals.should =~ [animal1, animal2]
  end
end

describe Animal, ".search" do

  context "with no search term" do

    it "returns all animals when no params" do
      animal1 = Animal.gen
      animal2 = Animal.gen

      animals = Animal.search("")

      animals.count.should == 2
      animals.should =~ [animal1, animal2]
    end
  end

  context "with numeric search term" do

    it "returns animal that matches id" do
       animal1 = Animal.gen :id => 1234567890
       animal2 = Animal.gen :id => 1234567

       animals = Animal.search("1234567")

       animals.count.should == 1
       animals.should == [animal2]
     end

    it "returns animal that matches microchip" do
       animal1 = Animal.gen :microchip => 1234567890
       animal2 = Animal.gen :microchip => 1234567

       animals = Animal.search("1234567")

       animals.count.should == 1
       animals.should == [animal2]
     end
  end

  context "with alphanumeric search term" do

    it "returns all animals with the name like" do
      animal1 = Animal.gen :name => "DoggieTown"
      animal2 = Animal.gen :name => "DogTown"
      animal3 = Animal.gen :name => "KittyTown"

      animals = Animal.search("dog")

      animals.count.should == 2
      animals.should =~ [animal1, animal2]
    end

    it "returns all animals with the microchip like" do
      animal1 = Animal.gen :microchip => "DoggieTown"
      animal2 = Animal.gen :microchip => "DogTown"
      animal3 = Animal.gen :microchip => "KittyTown"

      animals = Animal.search("dog")

      animals.count.should == 2
      animals.should =~ [animal1, animal2]
    end

    it "returns all animals with the description like" do
      animal1 = Animal.gen :description => "DoggieTown"
      animal2 = Animal.gen :description => "DogTown"
      animal3 = Animal.gen :description => "KittyTown"

      animals = Animal.search("dog")

      animals.count.should == 2
      animals.should =~ [animal1, animal2]
    end

    it "returns all animals with the primary breed like" do
      animal1 = Animal.gen :primary_breed => "DoggieTown"
      animal2 = Animal.gen :primary_breed => "DogTown"
      animal3 = Animal.gen :primary_breed => "KittyTown"

      animals = Animal.search("dog")

      animals.count.should == 2
      animals.should =~ [animal1, animal2]
    end

    it "returns all animals with the secondary breed like" do
      animal1 = Animal.gen :secondary_breed => "DoggieTown"
      animal2 = Animal.gen :secondary_breed => "DogTown"
      animal3 = Animal.gen :secondary_breed => "KittyTown"

      animals = Animal.search("dog")

      animals.count.should == 2
      animals.should =~ [animal1, animal2]
    end
  end
end

describe Animal, ".recent_activity" do

  it "returns a limited number of recent animals" do
    animal1 = Animal.gen :updated_at => Time.now - 2.days
    animal2 = Animal.gen :updated_at => Time.now
    animal3 = Animal.gen :updated_at => Time.now - 10.days

    animals = Animal.recent_activity(10)

    animals.should == [animal2, animal1, animal3]
  end
end

describe Animal, ".api_lookup" do

  it "returns a list of available animals because no status provided" do
    animal1 = Animal.gen :animal_status_id => 1
    animal2 = Animal.gen :animal_status_id => 2
    animal3 = Animal.gen :animal_status_id => 16

    animals = Animal.api_lookup(nil, nil)

    animals.should == [animal1, animal3]
  end

  it "returns a list of animals per statuses provided" do
    animal1 = Animal.gen :animal_status_id => 1
    animal2 = Animal.gen :animal_status_id => 2
    animal3 = Animal.gen :animal_status_id => 16

    animals = Animal.api_lookup(nil, [2])

    animals.should == [animal2]
  end

  it "returns a list of animals per types provided" do
    type1 = AnimalType.gen
    type2 = AnimalType.gen

    animal1 = Animal.gen :animal_status_id => 1, :animal_type => type1
    animal2 = Animal.gen :animal_status_id => 2, :animal_type => type1
    animal3 = Animal.gen :animal_status_id => 16, :animal_type => type2

    animals = Animal.api_lookup([type1.id], nil)

    animals.should == [animal1]
  end

  it "returns a list of animals per statuses and types provided" do
    type1 = AnimalType.gen
    type2 = AnimalType.gen

    animal1 = Animal.gen :animal_status_id => 1, :animal_type => type1
    animal2 = Animal.gen :animal_status_id => 2, :animal_type => type1
    animal3 = Animal.gen :animal_status_id => 16, :animal_type => type2

    animals = Animal.api_lookup([type1.id], [2])

    animals.should == [animal2]
  end

  it "returns a list of animals ordered by euthanasia_date" do
    next_month = Date.today + 1.month
    next_week = Date.today + 7.days
    animal1 = Animal.gen(
      :animal_status_id => 1,
      :euthanasia_date_day => next_month.day,
      :euthanasia_date_month => next_month.month,
      :euthanasia_date_year => next_month.year
    )
    animal2 = Animal.gen(
      :animal_status_id => 1,
      :euthanasia_date_day => next_week.day,
      :euthanasia_date_month => next_week.month,
      :euthanasia_date_year => next_week.year
    )
    animal3 = Animal.gen(:animal_status_id => 1)

    animals = Animal.api_lookup(nil, nil)

    animals.should == [animal2, animal1, animal3]
  end
end

describe Animal, ".community_animals" do

  before do
    @kill_shelter = Shelter.gen :is_kill_shelter => true
    @no_kill_shelter = Shelter.gen :is_kill_shelter => false

    @available_kill = Animal.gen :shelter => @kill_shelter, :animal_status_id => 1
    @pending_kill = Animal.gen :shelter => @kill_shelter, :animal_status_id => 16
    @adopted_kill = Animal.gen :shelter => @kill_shelter, :animal_status_id => 2

    @available_no_kill = Animal.gen :shelter => @no_kill_shelter, :animal_status_id => 1
    @pending_no_kill = Animal.gen :shelter => @no_kill_shelter, :animal_status_id => 16
    @adopted_no_kill = Animal.gen :shelter => @no_kill_shelter, :animal_status_id => 2
  end

  it "returns filtered animal by shelter ids" do
    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id])
    animals.should =~ [
      @available_kill,
      @pending_kill,
      @available_no_kill,
      @pending_no_kill
    ]
  end

  it "returns a sorted list of animals" do
    @available_kill.update_column(:euthanasia_date, Date.today)
    @pending_kill.update_column(:euthanasia_date, Date.today + 2.days)

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id])

    animals.count.should == 4

    # Only checking the kill shelter order because it is all that matters in the ordering
    animals[0].should == @available_kill
    animals[1].should == @pending_kill
  end

  it "returns filtered animal by euthanasia" do
    filters = { :euthanasia_only => true }

    @available_kill.update_column(:euthanasia_date, Date.today)
    @pending_kill.update_column(:euthanasia_date, Date.today)
    @adopted_kill.update_column(:euthanasia_date, Date.today + 4.weeks)
    @available_no_kill.update_column(:euthanasia_date, Date.today)

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id], filters)
    animals.should =~ [@available_kill, @pending_kill]
  end

  it "returns filtered animal by special needs" do
    filters = { :special_needs_only => true }

    @available_kill.update_column(:has_special_needs, true)
    @pending_kill.update_column(:has_special_needs, false)
    @adopted_kill.update_column(:has_special_needs, true)
    @available_no_kill.update_column(:has_special_needs, false)

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id], filters)
    animals.should =~ [@available_kill]
  end

  it "returns filtered animal by animal type" do
    filters = { :animal_type => 1 }

    @available_kill.update_column(:animal_type_id, 1)
    @pending_kill.update_column(:animal_type_id, 1)
    @adopted_kill.update_column(:animal_type_id, 2)
    @available_no_kill.update_column(:animal_type_id, 1)

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id], filters)
    animals.should =~ [@available_kill, @pending_kill, @available_no_kill]
  end

  it "returns filtered animal by breed" do
    filters = { :breed => "lab" }

    @available_kill.update_column(:primary_breed, "lab")
    @pending_kill.update_column(:secondary_breed, "lab")
    @adopted_kill.update_column(:primary_breed, "lab")
    @available_no_kill.update_column(:secondary_breed, "lab")

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id], filters)
    animals.should =~ [@available_kill, @pending_kill, @available_no_kill]
  end

  it "returns filtered animal by sex" do
    filters = { :sex => "male" }

    @available_kill.update_column(:sex, "male")
    @pending_kill.update_column(:sex, "female")
    @adopted_kill.update_column(:sex, "male")
    @available_no_kill.update_column(:sex, "male")
    @pending_no_kill.update_column(:sex, "female")
    @adopted_no_kill.update_column(:sex, "male")

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id], filters)
    animals.should =~ [@available_kill, @available_no_kill]
  end

  it "returns filtered animal by animal statuses" do
    filters = { :animal_status => "2" }

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id], filters)
    animals.should =~ [@adopted_kill, @adopted_no_kill]
  end
end

describe Animal, ".search_by_name" do

  it "returns an animal based on the id" do
    animal1 = Animal.gen
    animal2 = Animal.gen

    animals = Animal.search_by_name(animal1.id.to_s)
    animals.count.should == 1
    animals.should == [animal1]
  end

  it "returns a list of animals based on the name" do
    animal1 = Animal.gen :name => "doggie"
    animal2 = Animal.gen :name => "dog"
    animal3 = Animal.gen :name => "kittie"

    animals = Animal.search_by_name("dog")
    animals.count.should == 2
    animals.should =~ [animal1, animal2]
  end
end

describe Animal, ".filter_by_type_status" do

  it "returns animals that are only active" do
    animal1 = Animal.gen :animal_status_id => 1
    animal2 = Animal.gen :animal_status_id => 3
    animal3 = Animal.gen :animal_status_id => 2

    animals = Animal.filter_by_type_status(nil, "active")
    animals.count.should == 2
    animals.should =~ [animal1, animal2]
  end

  it "returns animals that are only non-active" do
    animal1 = Animal.gen :animal_status_id => 1
    animal2 = Animal.gen :animal_status_id => 3
    animal3 = Animal.gen :animal_status_id => 2

    animals = Animal.filter_by_type_status(nil, "non_active")
    animals.count.should == 1
    animals.should =~ [animal3]
  end

  it "returns a list of animals based on the type" do
    animal_type1 = AnimalType.gen
    animal_type2 = AnimalType.gen

    animal1 = Animal.gen :animal_type => animal_type1
    animal2 = Animal.gen :animal_type => animal_type2
    animal3 = Animal.gen :animal_type => animal_type1

    animals = Animal.filter_by_type_status(animal_type1.id, nil)
    animals.count.should == 2
    animals.should =~ [animal1, animal3]
  end

  it "returns a list of animals based on the status" do
    animal1 = Animal.gen :animal_status_id => 1
    animal2 = Animal.gen :animal_status_id => 3
    animal3 = Animal.gen :animal_status_id => 2

    animals = Animal.filter_by_type_status(nil, 3)
    animals.count.should == 1
    animals.should =~ [animal2]
  end

  it "returns a list of animals based on the type and status" do
    animal_type1 = AnimalType.gen
    animal_type2 = AnimalType.gen

    animal1 = Animal.gen :animal_type => animal_type1, :animal_status_id => 1
    animal2 = Animal.gen :animal_type => animal_type2, :animal_status_id => 2
    animal3 = Animal.gen :animal_type => animal_type1, :animal_status_id => 3

    animals = Animal.filter_by_type_status(animal_type1.id, 1)
    animals.count.should == 1
    animals.should =~ [animal1]
  end
end

describe Animal, ".count_by_type" do

  it "returns a count and animal type name" do
    type1 = AnimalType.gen
    type2 = AnimalType.gen

    animal1 = Animal.gen :animal_type => type1
    animal2 = Animal.gen :animal_type => type2
    animal3 = Animal.gen :animal_type => type1

    results = Animal.count_by_type

    MultiJson.load(results.to_json).should =~ [{
      "animal" => {
        "count" => 2,
        "name" => type1.name
      }
    }, {
      "animal" =>{
        "count" => 1,
        "name" => type2.name
      }
    }]
  end
end

describe Animal, ".count_by_status" do

  it "returns a count and animal type name" do
    status1 = AnimalStatus.gen
    status2 = AnimalStatus.gen

    animal1 = Animal.gen :animal_status => status1
    animal2 = Animal.gen :animal_status => status2
    animal3 = Animal.gen :animal_status => status1

    results = Animal.count_by_status

    MultiJson.load(results.to_json).should =~ [{
      "animal" => {
        "count" => 2,
        "name" => status1.name
      }
    }, {
      "animal" =>{
        "count" => 1,
        "name" => status2.name
      }
    }]
  end
end

describe Animal, ".current_month" do

  it "returns animals that had their status change this month" do
    animal1 = Animal.gen
    animal2 = Animal.gen
    animal3 = Animal.gen

    animal1.update_column(:status_change_date, Date.today)
    animal2.update_column(:status_change_date, Date.today + 1.month)
    animal3.update_column(:status_change_date, Date.today - 1.day)

    animals = Animal.current_month
    animals.should =~ [animal1, animal3]
  end
end

describe Animal, ".year_to_date" do
  it "returns animals that had their status change this year" do
    animal1 = Animal.gen
    animal2 = Animal.gen
    animal3 = Animal.gen

    animal1.update_column(:status_change_date, Date.today)
    animal2.update_column(:status_change_date, Date.today + 1.year)
    animal3.update_column(:status_change_date, Date.today - 1.day)

    animals = Animal.year_to_date
    animals.should =~ [animal1, animal3]
  end
end

describe Animal, ".type_by_month_year" do

  it "returns a count and animal type for the month and year for all shelters" do
    shelter = Shelter.gen

    type1 = AnimalType.gen
    type2 = AnimalType.gen

    animal1 = Animal.gen :shelter => shelter, :animal_type => type1
    animal2 = Animal.gen :shelter => shelter, :animal_type => type2

    history1 = StatusHistory.gen(
      :shelter => shelter,
      :animal => animal1,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )
    history2 = StatusHistory.gen(
      :shelter => shelter,
      :animal => animal2,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )
    history3 = StatusHistory.gen(
      :shelter => shelter,
      :animal => animal1,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )
    history4 = StatusHistory.gen(
      :shelter => shelter,
      :animal => animal1,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2014")
    )

    results = Animal.type_by_month_year("07", "2013", nil, nil)
    MultiJson.load(results.to_json).should =~ [{
      "animal" => {
        "count" => 2,
        "name" => type1.name
      }
    }, {
      "animal" =>{
        "count" => 1,
        "name" => type2.name
      }
    }]
  end

  it "returns a count and animal type for the month and year based on a shelter id" do
    shelter1 = Shelter.gen
    shelter2 = Shelter.gen

    type1 = AnimalType.gen
    type2 = AnimalType.gen

    animal1 = Animal.gen :shelter => shelter1, :animal_type => type1
    animal2 = Animal.gen :shelter => shelter2, :animal_type => type2

    history1 = StatusHistory.gen(
      :shelter => shelter1,
      :animal => animal1,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )
    history3 = StatusHistory.gen(
      :shelter => shelter2,
      :animal => animal2,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )

    results = Animal.type_by_month_year("07", "2013", shelter1.id, nil)
    MultiJson.load(results.to_json).should =~ [{
      "animal" => {
        "count" => 1,
        "name" => type1.name
      }
    }]
  end

  it "returns a count and animal type for the month and year based on a state" do
    shelter1 = Shelter.gen :state => "PA"
    shelter2 = Shelter.gen :state => "CA"

    type1 = AnimalType.gen
    type2 = AnimalType.gen

    animal1 = Animal.gen :shelter => shelter1, :animal_type => type1
    animal2 = Animal.gen :shelter => shelter2, :animal_type => type2

    history1 = StatusHistory.gen(
      :shelter => shelter1,
      :animal => animal1,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )
    history3 = StatusHistory.gen(
      :shelter => shelter2,
      :animal => animal2,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )

    results = Animal.type_by_month_year("07", "2013", nil, "CA")
    MultiJson.load(results.to_json).should =~ [{
      "animal" => {
        "count" => 1,
        "name" => type2.name
      }
    }]
  end
end

describe Animal, ".intake_totals_by_month" do

  it "returns counts for a year without animal types" do
    Animal.gen :created_at => DateTime.parse("July 1, 2013")
    Animal.gen :created_at => DateTime.parse("July 1, 2013")
    Animal.gen :created_at => DateTime.parse("Jan 1, 2013")
    Animal.gen :created_at => DateTime.parse("May 1, 2013")
    Animal.gen :created_at => DateTime.parse("Sept 1, 2013")
    Animal.gen :created_at => DateTime.parse("Nov 1, 2013")
    Animal.gen :created_at => DateTime.parse("Sept 1, 2013")

    results = Animal.intake_totals_by_month("2013")
    MultiJson.load(results.to_json).should =~ [{
      "animal" => {
        "april" => 0,
        "august" => 0,
        "december" => 0,
        "february" => 0,
        "january" => 1,
        "july" => 2,
        "june" => 0,
        "march" => 0,
        "may" => 1,
        "november" => 1,
        "october" => 0,
        "september" => 2
      }
    }]
  end

  it "returns counts for a year with animal types" do
    type1 = AnimalType.gen
    type2 = AnimalType.gen

    Animal.gen :animal_type => type1, :created_at => DateTime.parse("July 1, 2013")
    Animal.gen :animal_type => type1, :created_at => DateTime.parse("July 1, 2013")
    Animal.gen :animal_type => type2, :created_at => DateTime.parse("Jan 1, 2013")
    Animal.gen :animal_type => type2, :created_at => DateTime.parse("May 1, 2013")
    Animal.gen :animal_type => type2, :created_at => DateTime.parse("Sept 1, 2013")
    Animal.gen :animal_type => type1, :created_at => DateTime.parse("Nov 1, 2013")
    Animal.gen :animal_type => type1, :created_at => DateTime.parse("Sept 1, 2013")

    results = Animal.intake_totals_by_month("2013", true)
    MultiJson.load(results.to_json).should =~ [{
      "animal" => {
        "april" => 0, "august" => 0, "december" => 0, "february" => 0, "january" => 0, "july" => 2,
        "june" => 0, "march" => 0, "may" => 0, "november" => 1, "october" => 0, "september" => 1
      }
    }, {
      "animal" => {
        "april" => 0, "august" => 0, "december" => 0, "february" => 0, "january" => 1, "july" => 0,
        "june" => 0, "march" => 0, "may" => 1, "november" => 0, "october" => 0, "september" => 1
      }
    }]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Animal, "#animal_type" do

  it "belongs to an animal type" do
    animal_type = AnimalType.new
    animal = Animal.new :animal_type => animal_type

    animal.animal_type.should == animal_type
  end

  it "returns a readonly animal type" do
    animal = Animal.gen
    animal.reload.animal_type.should be_readonly
  end
end

describe Animal, "#animal_status" do

  it "belongs to an animal status" do
    animal_status = AnimalStatus.new
    animal = Animal.new :animal_status => animal_status

    animal.animal_status.should == animal_status
  end

  it "returns a readonly animal status" do
    animal = Animal.gen
    animal.reload.animal_status.should be_readonly
  end
end

describe Animal, "#accommodation" do

  it "belongs to an accommodation" do
    accommodation = Accommodation.new
    animal = Animal.new :accommodation => accommodation

    animal.accommodation.should == accommodation
  end
end

describe Animal, "#shelter" do

  it "belongs to an shelter" do
    shelter = Shelter.new
    animal = Animal.new :shelter => shelter

    animal.shelter.should == shelter
  end
end

describe Animal, "#placements" do

  before do
    @animal = Animal.gen
    @placement1 = Placement.gen :animal => @animal
    @placement2 = Placement.gen :animal => @animal
  end

  it "returns a list of placements" do
    @animal.placements.count.should == 2
    @animal.placements.should =~ [@placement1, @placement2]
  end

  it "destroy all placements associated to the animal" do
    @animal.placements.count.should == 2
    @animal.destroy
    @animal.placements.count.should == 0
  end
end

describe Animal, "#notes" do

  before do
    @animal = Animal.gen
    @note1 = Note.gen :notable => @animal
    @note2 = Note.gen :notable => @animal
  end

  it "returns a list of notes" do
    @animal.notes.count.should == 2
    @animal.notes.should =~ [@note1, @note2]
  end

  it "destroy all notes associated to the animal" do
    @animal.notes.count.should == 2
    @animal.destroy
    @animal.notes.count.should == 0
  end
end

describe Animal, "#alerts" do

  before do
    @animal = Animal.gen
    @alert1 = Alert.gen :alertable => @animal
    @alert2 = Alert.gen :alertable => @animal
  end

  it "returns a list of alerts" do
    @animal.alerts.count.should == 2
    @animal.alerts.should =~ [@alert1, @alert2]
  end

  it "destroy all alerts associated to the animal" do
    @animal.alerts.count.should == 2
    @animal.destroy
    @animal.alerts.count.should == 0
  end
end

describe Animal, "#tasks" do

  before do
    @animal = Animal.gen
    @task1 = Task.gen :taskable => @animal
    @task2 = Task.gen :taskable => @animal
  end

  it "returns a list of tasks" do
    @animal.tasks.count.should == 2
    @animal.tasks.should =~ [@task1, @task2]
  end

  it "destroy all tasks associated to the animal" do
    @animal.tasks.count.should == 2
    @animal.destroy
    @animal.tasks.count.should == 0
  end
end

describe Animal, "#transfers" do

  before do
    @animal = Animal.gen
    @transfer1 = Transfer.gen :animal => @animal
    @transfer2 = Transfer.gen :animal => @animal
  end

  it "returns a list of transfers" do
    @animal.transfers.count.should == 2
    @animal.transfers.should =~ [@transfer1, @transfer2]
  end

  it "destroy all transfers associated to the animal" do
    @animal.transfers.count.should == 2
    @animal.destroy
    @animal.transfers.count.should == 0
  end
end

describe Animal, "#status_histories" do

  before do
    @animal = Animal.gen
    @status_history1 = StatusHistory.gen :animal => @animal
    @status_history2 = StatusHistory.gen :animal => @animal
  end

  it "returns a list of status_histories" do
    @animal.status_histories.count.should == 3
    @animal.status_histories.should include(@status_history1, @status_history2)
  end

  it "destroy all status_histories associated to the animal" do
    @animal.status_histories.count.should == 3
    @animal.destroy
    @animal.status_histories.count.should == 0
  end
end

describe Animal, "#photos" do

  before do
    @animal = Animal.gen
    @photo1 = Photo.gen :attachable => @animal
    @photo2 = Photo.gen :attachable => @animal
  end

  it "returns a list of photos" do
    @animal.photos.count.should == 2
    @animal.photos.should =~ [@photo1, @photo2]
  end

  it "destroy all photos associated to the animal" do
    @animal.photos.count.should == 2
    @animal.destroy
    @animal.photos.count.should == 0
  end
end

describe Animal, "#full_breed" do

  it "returns the full breed when only primary breed" do
    animal = Animal.new :primary_breed => "Labrador Retriever"
    animal.full_breed.should == "Labrador Retriever"
  end

  it "returns the full breed when primary breed and is a mix breed" do
    animal = Animal.new(
      :primary_breed => "Labrador Retriever",
      :secondary_breed => "",
      :is_mix_breed => true
    )
    animal.full_breed.should == "Labrador Retriever Mix"
  end

  it "returns the full breed when primary breed and is a mix breed with secondary breed" do
    animal = Animal.new(
      :primary_breed => "Labrador Retriever",
      :secondary_breed => "Border Collie",
      :is_mix_breed => true
    )
    animal.full_breed.should == "Labrador Retriever & Border Collie Mix"
  end
end

describe Animal, "#stopped?" do

  it "returns true if the animal has special needs" do
    animal1 = Animal.new :has_special_needs => true
    animal2 = Animal.new

    animal1.special_needs?.should == true
    animal2.special_needs?.should == false
  end
end

describe Animal, "#mix_breed?" do

  it "returns true if the animal is a mix breed" do
    animal1 = Animal.new :is_mix_breed => true
    animal2 = Animal.new :is_mix_breed => false

    animal1.mix_breed?.should == true
    animal2.mix_breed?.should == false
  end
end

describe Animal, "#sterilized?" do

  it "returns true if the animal is sterilized" do
    animal1 = Animal.new :is_sterilized => true
    animal2 = Animal.new :is_sterilized => false

    animal1.sterilized?.should == true
    animal2.sterilized?.should == false
  end
end

