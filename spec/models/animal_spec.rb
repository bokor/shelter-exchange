require "spec_helper"

describe Animal do

  it_should_behave_like Statusable
  it_should_behave_like Typeable
  it_should_behave_like Uploadable

  it "has a default scope" do
    expect(Animal.scoped.to_sql).to eq(Animal.order('animals.updated_at DESC').to_sql)
  end

  it "validates presence of name" do
    animal = Animal.new :name => nil
    expect(animal).to have(1).error_on(:name)
    expect(animal.errors[:name]).to match_array(["cannot be blank"])
  end

  it "validates presence of animal type id" do
    animal = Animal.new :animal_type_id => nil
    expect(animal).to have(1).error_on(:animal_type_id)
    expect(animal.errors[:animal_type_id]).to match_array(["needs to be selected"])
  end

  it "validates presence of animal status id" do
    animal = Animal.new :animal_status_id => nil
    expect(animal).to have(1).error_on(:animal_status_id)
    expect(animal.errors[:animal_status_id]).to match_array(["needs to be selected"])
  end

  it "validates breed of primary breed" do
    animal = Animal.gen :primary_breed => nil, :animal_type_id => 1
    expect(animal).to have(1).error_on(:primary_breed)
    expect(animal.errors[:primary_breed]).to match_array(["cannot be blank"])

    animal = Animal.new :primary_breed => "aaa", :animal_type_id => 1
    expect(animal).to have(1).error_on(:primary_breed)
    expect(animal.errors[:primary_breed]).to match_array(["must contain a valid breed name"])
  end

  it "validates breed of secondary breed" do
    animal = Animal.new :is_mix_breed => true, :secondary_breed => nil, :animal_type_id => 1
    expect(animal).to have(0).error_on(:secondary_breed)

    animal = Animal.new :is_mix_breed => true, :secondary_breed => "aaa", :animal_type_id => 1
    expect(animal).to have(1).error_on(:secondary_breed)
    expect(animal.errors[:secondary_breed]).to match_array(["must contain a valid breed name"])
  end

  it "validates presence of sex" do
    animal = Animal.new :sex => nil
    expect(animal).to have(1).error_on(:sex)
    expect(animal.errors[:sex]).to match_array(["cannot be blank"])
  end

  it "validates presence of age if status is active" do
    animal = Animal.new :age => nil, :animal_status_id => 1
    expect(animal).to have(1).error_on(:age)
    expect(animal.errors[:age]).to match_array(["needs to be selected"])

    animal = Animal.new :age => nil, :animal_status_id => 2
    expect(animal).to have(0).error_on(:age)
  end

  it "validates presence of size if status is active" do
    animal = Animal.new :size => nil, :animal_status_id => 1
    expect(animal).to have(1).error_on(:size)
    expect(animal.errors[:size]).to match_array(["needs to be selected"])

    animal = Animal.new :size => nil, :animal_status_id => 2
    expect(animal).to have(0).error_on(:size)
  end

  it "validates uniqueness of microchip" do
    shelter = Shelter.gen
    Animal.gen :microchip => "microchip", :shelter => shelter

    animal = Animal.new :microchip => "microchip", :shelter => shelter
    expect(animal).to have(1).error_on(:microchip)
    expect(animal.errors[:microchip]).to match_array([
      "already exists in your shelter. Please return to the main Animal page and search by this microchip number to locate this record."
    ])

    # Another Shelter
    animal = Animal.new :microchip => "microchip"
    expect(animal).to have(0).error_on(:microchip)
  end

  it "validates allows blank for microchip" do
    animal = Animal.new :microchip => nil
    expect(animal).to have(0).error_on(:microchip)
  end

  it "validates presence of special needs" do
    animal = Animal.new :has_special_needs => true
    expect(animal).to have(1).error_on(:special_needs)
    expect(animal.errors[:special_needs]).to match_array(["cannot be blank"])
  end

  it "validates video url format of video url" do
    animal = Animal.new :video_url => "http://vimeo.com/1234"
    expect(animal).to have(1).error_on(:video_url)
    expect(animal.errors[:video_url]).to match_array(["incorrect You Tube URL format"])
  end

  it "validates allows blank for video url" do
    animal = Animal.new :video_url => nil
    expect(animal).to have(0).error_on(:video_url)
  end

  it "validates date format of date of birth before today" do
    today = Date.today + 1.month
    animal = Animal.gen(
      :date_of_birth_day => today.day,
      :date_of_birth_month => today.month,
      :date_of_birth_year => today.year
    )
    expect(animal).to have(1).error_on(:date_of_birth)
    expect(animal.errors[:date_of_birth]).to match_array(["has to be before today's date"])
  end

  it "validates date format of date of birth invalid date" do
    today = Date.today
    animal = Animal.new(
      :date_of_birth_day => today.day,
      :date_of_birth_month => today.month,
      :date_of_birth_year => nil
    )
    expect(animal).to have(1).error_on(:date_of_birth)
    expect(animal.errors[:date_of_birth]).to match_array(["is an invalid date format"])
  end

  it "validates date format of arrival date invalid date" do
    today = Date.today
    animal = Animal.new(
      :arrival_date_day => today.day,
      :arrival_date_month => today.month,
      :arrival_date_year => nil
    )
    expect(animal).to have(1).error_on(:arrival_date)
    expect(animal.errors[:arrival_date]).to match_array(["is an invalid date format"])
  end

  it "validates date format of euthanasia date invalid date" do
    today = Date.today
    animal = Animal.new(
      :euthanasia_date_day => today.day,
      :euthanasia_date_month => today.month,
      :euthanasia_date_year => nil
    )
    expect(animal).to have(1).error_on(:euthanasia_date)
    expect(animal.errors[:euthanasia_date]).to match_array(["is an invalid date format"])
  end

  context "Nested Attributes" do

    before do
      @image = File.open("#{Rails.root}/spec/data/images/photo.jpg")
    end

    it "accepts nested attributes for photos" do
      expect(Animal.count).to eq(0)
      expect(Photo.count).to eq(0)

      Animal.gen :photos_attributes => [{:image => @image}]

      expect(Animal.count).to eq(1)
      expect(Photo.count).to eq(1)
    end

    it "rejects nested attributes for photos" do
      expect(Animal.count).to eq(0)
      expect(Photo.count).to eq(0)

      Animal.gen :photos_attributes => [{:image => nil}]

      expect(Animal.count).to eq(1)
      expect(Photo.count).to eq(0)
    end

    it "destroys nested photos" do
      animal = Animal.gen :photos_attributes => [{:image => @image}]

      expect(Animal.count).to eq(1)
      expect(Photo.count).to eq(1)

      animal.destroy

      expect(Animal.count).to eq(0)
      expect(Photo.count).to eq(0)
    end
  end

  context "Before Save" do

    it "cleans the description to remove all of the MS formatting" do
      animal = Animal.gen(
        :description => "\u2036\u201F\u2035\u2032\u2013\u02C6\u2039\u203A\u2013\u2014\u2026\u00A9\u00AE\u2122\u00BC\u00BD\u00BE\u02DC"
      )
      expect(animal.description).to eq("\"\"''-^<>--...&copy;&reg;&trade;&frac14;&frac12;&frac34;")
    end

    it "strips the description" do
      animal = Animal.gen(
        :description => "   hi    "
      )
      expect(animal.description).to eq("hi")
    end

    it "removed secondary breed when the mixed breed is false" do
      animal = Animal.gen(
        :secondary_breed => "test",
        :is_mix_breed => false
      )
      expect(animal.secondary_breed).to be_nil
    end

    it "removed special needs when the has special needs is false" do
      animal = Animal.gen(
        :special_needs => "test",
        :has_special_needs => false
      )
      expect(animal.special_needs).to be_nil
    end

    it "changes the status date for a new record" do
      animal = Animal.gen
      expect(animal.status_change_date).to eq(Date.today)
    end

    it "changes the status date when the animal status changes" do
      animal = Animal.gen :animal_status_id => 1
      animal.update_attributes(:status_change_date => Date.today - 1.month)

      expect(animal.status_change_date).to eq(Date.today - 1.month)

      animal.update_attributes(:animal_status_id => 2)

      expect(animal.status_change_date).to eq(Date.today)
    end
  end

  context "After Validation" do

    it "updates the breed names to exactly match the ones in the database" do
      Breed.gen(:name => "Labrador Retriever")
      Breed.gen(:name => "Border Collie")

      animal = Animal.gen(
        :primary_breed => " labrador retriever    ",
        :secondary_breed => " border collie  "
      )

      expect(animal.primary_breed).to eq("Labrador Retriever")
      expect(animal.secondary_breed).to eq("Border Collie")
    end
  end

  context "After Save" do

    it "creates status history for a new record" do
      expect(Animal.count).to eq(0)
      expect(StatusHistory.count).to eq(0)

      Animal.gen

      expect(Animal.count).to eq(1)
      expect(StatusHistory.count).to eq(1)
    end

    it "creates status history when the animal status has changed" do
      expect(Animal.count).to eq(0)
      expect(StatusHistory.count).to eq(0)

      animal = Animal.gen :status_history_reason => "New Record"

      expect(Animal.count).to eq(1)
      expect(StatusHistory.count).to eq(1)

      animal.animal_status = AnimalStatus.gen
      animal.status_history_reason = "Status Updated"
      animal.save

      expect(Animal.count).to eq(1)
      expect(StatusHistory.count).to eq(2)

      histories = StatusHistory.all
      expect(histories.map(&:reason)).to match_array(["New Record", "Status Updated"])
    end

    it "creates status history when the shelter has changed" do
      expect(Animal.count).to eq(0)
      expect(StatusHistory.count).to eq(0)

      animal = Animal.gen :status_history_reason => "New Record"

      expect(Animal.count).to eq(1)
      expect(StatusHistory.count).to eq(1)

      shelter = Shelter.gen
      animal.shelter = shelter
      animal.status_history_reason = "New Transfer"
      animal.save

      expect(Animal.count).to eq(1)
      expect(StatusHistory.count).to eq(2)

      histories = StatusHistory.all
      expect(histories[0].reason).to eq("New Record")
      expect(histories[1].reason).to eq("New Transfer")
    end

    it "enqueues a job to update remote animals" do
      shelter = Shelter.gen
      Integration.gen :shelter => shelter, :type => "Integration::AdoptAPet"
      Integration.gen :shelter => shelter, :type => "Integration::Petfinder"
      animal = Animal.build :shelter => shelter, :animal_status_id => AnimalStatus::AVAILABLE[0]

      expect(Delayed::Job).to receive(:enqueue).with(AdoptAPetJob.new(shelter.id))
      expect(Delayed::Job).to receive(:enqueue).with(PetfinderJob.new(shelter.id))

      animal.save!
    end

    it "lints the facebook url for an updated animal" do
      shelter = Shelter.gen
      animal_status_old = AnimalStatus.gen
      animal_status_new = AnimalStatus.gen
      animal = Animal.gen :shelter => shelter, :animal_status => animal_status_old

      allow(Rails.env).to receive(:production?).and_return(true)
      expect(Delayed::Job).to receive(:enqueue).with(FacebookLinterJob.new(animal.id))

      animal.update_attribute(:animal_status_id, animal_status_new.id)
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe Animal, "::SEX" do
  it "contains a default list of genders" do
    expect(Animal::SEX).to match_array(["male", "female"])
  end
end

describe Animal, "::AGES" do
  it "contains a default list of ages" do
    expect(Animal::AGES).to match_array(["baby", "young", "adult", "senior"])
  end
end

describe Animal, "::SIZES" do
  it "contains a default list of sizes" do
    expect(Animal::SIZES).to eq({
      :S => "Small",
      :M => "Medium",
      :L => "Large",
      :XL => "X-Large"
    })
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Animal, ".latest" do

  it "returns the latest animals for a specific status and limit" do
    animal1 = Animal.gen(:animal_status_id => 1)
    animal2 = Animal.gen(:animal_status_id => 1)
    animal3 = Animal.gen(:animal_status_id => 1)
    Animal.gen(:animal_status_id => 2)

    animal1.update_attribute(:status_change_date, Date.today)
    animal2.update_attribute(:status_change_date, Date.today - 2.days)
    animal3.update_attribute(:status_change_date, Date.today - 1.days)

    animals = Animal.latest(:available_for_adoption, 4)

    expect(animals.count).to eq(3)
    expect(animals).to match_array([animal1, animal3, animal2])
  end
end

describe Animal, ".auto_complete" do

  it "returns the animals like the name parameter" do
    animal1 = Animal.gen(:name => "Doggie")
    animal2 = Animal.gen(:name => "Dog")
    Animal.gen(:name => "Cat")

    animals = Animal.auto_complete("dog")

    expect(animals.count).to eq(2)
    expect(animals).to match_array([animal1, animal2])
  end
end

describe Animal, ".search" do

  context "with no search term" do

    it "returns all animals when no params" do
      animal1 = Animal.gen
      animal2 = Animal.gen

      animals = Animal.search("")

      expect(animals.count).to eq(2)
      expect(animals).to match_array([animal1, animal2])
    end
  end

  context "with numeric search term" do

    it "returns animal that matches id" do
       Animal.gen :id => 1234567890
       animal2 = Animal.gen :id => 1234567

       animals = Animal.search("1234567")

       expect(animals.count).to eq(1)
       expect(animals).to match_array([animal2])
     end

    it "returns animal that matches microchip" do
       Animal.gen :microchip => 1234567890
       animal2 = Animal.gen :microchip => 1234567

       animals = Animal.search("1234567")

       expect(animals.count).to eq(1)
       expect(animals).to match_array([animal2])
     end
  end

  context "with alphanumeric search term" do

    it "returns all animals with the name like" do
      animal1 = Animal.gen :name => "DoggieTown"
      animal2 = Animal.gen :name => "DogTown"
      Animal.gen :name => "KittyTown"

      animals = Animal.search("dog")

      expect(animals.count).to eq(2)
      expect(animals).to match_array([animal1, animal2])
    end

    it "returns all animals with the microchip like" do
      animal1 = Animal.gen :microchip => "DoggieTown"
      animal2 = Animal.gen :microchip => "DogTown"
      Animal.gen :microchip => "KittyTown"

      animals = Animal.search("dog")

      expect(animals.count).to eq(2)
      expect(animals).to match_array([animal1, animal2])
    end

    it "returns all animals with the description like" do
      animal1 = Animal.gen :description => "DoggieTown"
      animal2 = Animal.gen :description => "DogTown"
      Animal.gen :description => "KittyTown"

      animals = Animal.search("dog")

      expect(animals.count).to eq(2)
      expect(animals).to match_array([animal1, animal2])
    end

    it "returns all animals with the primary breed like" do
      animal1 = Animal.gen :primary_breed => "DoggieTown"
      animal2 = Animal.gen :primary_breed => "DogTown"
      Animal.gen :primary_breed => "KittyTown"

      animals = Animal.search("dog")

      expect(animals.count).to eq(2)
      expect(animals).to match_array([animal1, animal2])
    end

    it "returns all animals with the secondary breed like" do
      animal1 = Animal.gen :secondary_breed => "DoggieTown"
      animal2 = Animal.gen :secondary_breed => "DogTown"
      Animal.gen :secondary_breed => "KittyTown"

      animals = Animal.search("dog")

      expect(animals.count).to eq(2)
      expect(animals).to match_array([animal1, animal2])
    end
  end
end

describe Animal, ".recent_activity" do

  it "returns a limited number of recent animals" do
    animal1 = Animal.gen :updated_at => Time.now - 2.days
    animal2 = Animal.gen :updated_at => Time.now
    animal3 = Animal.gen :updated_at => Time.now - 10.days

    animals = Animal.recent_activity(10)

    expect(animals).to match_array([animal2, animal1, animal3])
  end
end

describe Animal, ".api_lookup" do

  it "returns a list of available animals because no status provided" do
    animal1 = Animal.gen :animal_status_id => 1
    animal2 = Animal.gen :animal_status_id => 16
    Animal.gen :animal_status_id => 2

    animals = Animal.api_lookup(nil, nil)

    expect(animals).to match_array([animal1, animal2])
  end

  it "returns a list of animals per statuses provided" do
    animal1 = Animal.gen :animal_status_id => 2
    Animal.gen :animal_status_id => 1
    Animal.gen :animal_status_id => 16

    animals = Animal.api_lookup(nil, [2])

    expect(animals).to match_array([animal1])
  end

  it "returns a list of animals per types provided" do
    type1 = AnimalType.gen
    type2 = AnimalType.gen

    animal1 = Animal.gen :animal_status_id => 1, :animal_type => type1
    Animal.gen :animal_status_id => 2, :animal_type => type1
    Animal.gen :animal_status_id => 16, :animal_type => type2

    animals = Animal.api_lookup([type1.id], nil)

    expect(animals).to match_array([animal1])
  end

  it "returns a list of animals per statuses and types provided" do
    type1 = AnimalType.gen
    type2 = AnimalType.gen

    animal1 = Animal.gen :animal_status_id => 2, :animal_type => type1
    Animal.gen :animal_status_id => 1, :animal_type => type1
    Animal.gen :animal_status_id => 16, :animal_type => type2

    animals = Animal.api_lookup([type1.id], [2])

    expect(animals).to match_array([animal1])
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

    expect(animals).to match_array([animal2, animal1, animal3])
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
    expect(animals).to match_array([
      @available_kill,
      @pending_kill,
      @available_no_kill,
      @pending_no_kill
    ])
  end

  it "returns a sorted list of animals" do
    @available_kill.update_column(:euthanasia_date, Date.today)
    @pending_kill.update_column(:euthanasia_date, Date.today + 2.days)

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id])

    expect(animals.count).to eq(4)

    # Only checking the kill shelter order because it is all that matters in the ordering
    expect(animals[0]).to eq(@available_kill)
    expect(animals[1]).to eq(@pending_kill)
  end

  it "returns filtered animal by euthanasia" do
    filters = { :euthanasia_only => true }

    @available_kill.update_column(:euthanasia_date, Date.today)
    @pending_kill.update_column(:euthanasia_date, Date.today)
    @adopted_kill.update_column(:euthanasia_date, Date.today + 4.weeks)
    @available_no_kill.update_column(:euthanasia_date, Date.today)

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id], filters)
    expect(animals).to match_array([@available_kill, @pending_kill])
  end

  it "returns filtered animal by special needs" do
    filters = { :special_needs_only => true }

    @available_kill.update_column(:has_special_needs, true)
    @pending_kill.update_column(:has_special_needs, false)
    @adopted_kill.update_column(:has_special_needs, true)
    @available_no_kill.update_column(:has_special_needs, false)

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id], filters)
    expect(animals).to match_array([@available_kill])
  end

  it "returns filtered animal by animal type" do
    filters = { :animal_type => 1 }

    @available_kill.update_column(:animal_type_id, 1)
    @pending_kill.update_column(:animal_type_id, 1)
    @adopted_kill.update_column(:animal_type_id, 2)
    @available_no_kill.update_column(:animal_type_id, 1)

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id], filters)
    expect(animals).to match_array([@available_kill, @pending_kill, @available_no_kill])
  end

  it "returns filtered animal by breed" do
    filters = { :breed => "lab" }

    @available_kill.update_column(:primary_breed, "lab")
    @pending_kill.update_column(:secondary_breed, "lab")
    @adopted_kill.update_column(:primary_breed, "lab")
    @available_no_kill.update_column(:secondary_breed, "lab")

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id], filters)
    expect(animals).to match_array([@available_kill, @pending_kill, @available_no_kill])
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
    expect(animals).to match_array([@available_kill, @available_no_kill])
  end

  it "returns filtered animal by animal statuses" do
    filters = { :animal_status => "2" }

    animals = Animal.community_animals([@kill_shelter.id, @no_kill_shelter.id], filters)
    expect(animals).to match_array([@adopted_kill, @adopted_no_kill])
  end
end

describe Animal, ".search_by_name" do

  it "returns an animal based on the id" do
    animal1 = Animal.gen
    Animal.gen

    animals = Animal.search_by_name(animal1.id.to_s)
    expect(animals.count).to eq(1)
    expect(animals).to match_array([animal1])
  end

  it "returns a list of animals based on the name" do
    animal1 = Animal.gen :name => "doggie"
    animal2 = Animal.gen :name => "dog"
    Animal.gen :name => "kittie"

    animals = Animal.search_by_name("dog")
    expect(animals.count).to eq(2)
    expect(animals).to match_array([animal1, animal2])
  end
end

describe Animal, ".filter_by_type_status" do

  it "returns animals that are only active" do
    animal1 = Animal.gen :animal_status_id => 1
    animal2 = Animal.gen :animal_status_id => 3
    Animal.gen :animal_status_id => 2

    animals = Animal.filter_by_type_status(nil, "active")
    expect(animals.count).to eq(2)
    expect(animals).to match_array([animal1, animal2])
  end

  it "returns animals that are only non-active" do
    animal1 = Animal.gen :animal_status_id => 2
    Animal.gen :animal_status_id => 1
    Animal.gen :animal_status_id => 3

    animals = Animal.filter_by_type_status(nil, "non_active")
    expect(animals.count).to eq(1)
    expect(animals).to match_array([animal1])
  end

  it "returns a list of animals based on the type" do
    animal_type1 = AnimalType.gen
    animal_type2 = AnimalType.gen

    animal1 = Animal.gen :animal_type => animal_type1
    animal2 = Animal.gen :animal_type => animal_type1
    Animal.gen :animal_type => animal_type2

    animals = Animal.filter_by_type_status(animal_type1.id, nil)
    expect(animals.count).to eq(2)
    expect(animals).to match_array([animal1, animal2])
  end

  it "returns a list of animals based on the status" do
    animal1 = Animal.gen :animal_status_id => 3
    Animal.gen :animal_status_id => 1
    Animal.gen :animal_status_id => 2

    animals = Animal.filter_by_type_status(nil, 3)
    expect(animals.count).to eq(1)
    expect(animals).to match_array([animal1])
  end

  it "returns a list of animals based on the type and status" do
    animal_type1 = AnimalType.gen
    animal_type2 = AnimalType.gen

    animal1 = Animal.gen :animal_type => animal_type1, :animal_status_id => 1
    Animal.gen :animal_type => animal_type2, :animal_status_id => 2
    Animal.gen :animal_type => animal_type1, :animal_status_id => 3

    animals = Animal.filter_by_type_status(animal_type1.id, 1)
    expect(animals.count).to eq(1)
    expect(animals).to match_array([animal1])
  end
end

describe Animal, ".count_by_type" do

  it "returns a count and animal type name" do
    type1 = AnimalType.gen
    type2 = AnimalType.gen

    Animal.gen :animal_type => type1
    Animal.gen :animal_type => type2
    Animal.gen :animal_type => type1

    results = Animal.count_by_type

    expect(MultiJson.load(results.to_json)).to match_array([{
      "animal" => {
        "count" => 2,
        "name" => type1.name
      }
    }, {
      "animal" =>{
        "count" => 1,
        "name" => type2.name
      }
    }])
  end
end

describe Animal, ".count_by_status" do

  it "returns a count and animal type name" do
    status1 = AnimalStatus.gen
    status2 = AnimalStatus.gen

    Animal.gen :animal_status => status1
    Animal.gen :animal_status => status2
    Animal.gen :animal_status => status1

    results = Animal.count_by_status

    expect(MultiJson.load(results.to_json)).to match_array([{
      "animal" => {
        "count" => 2,
        "name" => status1.name
      }
    }, {
      "animal" =>{
        "count" => 1,
        "name" => status2.name
      }
    }])
  end
end

describe Animal, ".current_month" do

  it "returns animals that had their status change this month" do
    animal1 = Animal.gen
    animal2 = Animal.gen
    animal3 = Animal.gen

    animal1.update_column(:status_change_date, Date.today)
    animal2.update_column(:status_change_date, Date.today + 1.month)
    animal3.update_column(:status_change_date, Date.today - 1.month)

    animals = Animal.current_month
    expect(animals).to match_array([animal1])
  end
end

describe Animal, ".year_to_date" do
  it "returns animals that had their status change this year" do
    animal1 = Animal.gen
    animal2 = Animal.gen
    animal3 = Animal.gen

    animal1.update_column(:status_change_date, Date.today)
    animal2.update_column(:status_change_date, Date.today + 1.year)
    animal3.update_column(:status_change_date, Date.today - 1.year)

    animals = Animal.year_to_date
    expect(animals).to match_array([animal1])
  end
end

describe Animal, ".type_by_month_year" do

  it "returns a count and animal type for the month and year for all shelters" do
    shelter = Shelter.gen

    type1 = AnimalType.gen
    type2 = AnimalType.gen

    animal1 = Animal.gen :shelter => shelter, :animal_type => type1
    animal2 = Animal.gen :shelter => shelter, :animal_type => type2

    StatusHistory.gen(
      :shelter => shelter,
      :animal => animal1,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )
    StatusHistory.gen(
      :shelter => shelter,
      :animal => animal2,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )
    StatusHistory.gen(
      :shelter => shelter,
      :animal => animal1,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )
    StatusHistory.gen(
      :shelter => shelter,
      :animal => animal1,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2014")
    )

    results = Animal.type_by_month_year("07", "2013", nil, nil)
    expect(MultiJson.load(results.to_json)).to match_array([{
      "animal" => {
        "count" => 2,
        "name" => type1.name
      }
    }, {
      "animal" =>{
        "count" => 1,
        "name" => type2.name
      }
    }])
  end

  it "returns a count and animal type for the month and year based on a shelter id" do
    shelter1 = Shelter.gen
    shelter2 = Shelter.gen

    type1 = AnimalType.gen
    type2 = AnimalType.gen

    animal1 = Animal.gen :shelter => shelter1, :animal_type => type1
    animal2 = Animal.gen :shelter => shelter2, :animal_type => type2

    StatusHistory.gen(
      :shelter => shelter1,
      :animal => animal1,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )
    StatusHistory.gen(
      :shelter => shelter2,
      :animal => animal2,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )

    results = Animal.type_by_month_year("07", "2013", shelter1.id, nil)
    expect(MultiJson.load(results.to_json)).to match_array([{
      "animal" => {
        "count" => 1,
        "name" => type1.name
      }
    }])
  end

  it "returns a count and animal type for the month and year based on a state" do
    shelter1 = Shelter.gen :state => "PA"
    shelter2 = Shelter.gen :state => "CA"

    type1 = AnimalType.gen
    type2 = AnimalType.gen

    animal1 = Animal.gen :shelter => shelter1, :animal_type => type1
    animal2 = Animal.gen :shelter => shelter2, :animal_type => type2

    StatusHistory.gen(
      :shelter => shelter1,
      :animal => animal1,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )
    StatusHistory.gen(
      :shelter => shelter2,
      :animal => animal2,
      :animal_status_id => 1,
      :created_at => DateTime.parse("July 1, 2013")
    )

    results = Animal.type_by_month_year("07", "2013", nil, "CA")
    expect(MultiJson.load(results.to_json)).to match_array([{
      "animal" => {
        "count" => 1,
        "name" => type2.name
      }
    }])
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
    expect(MultiJson.load(results.to_json)).to match_array([{
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
    }])
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
    expect(MultiJson.load(results.to_json)).to match_array([{
      "animal" => {
        "april" => 0, "august" => 0, "december" => 0, "february" => 0, "january" => 0, "july" => 2,
        "june" => 0, "march" => 0, "may" => 0, "november" => 1, "october" => 0, "september" => 1
      }
    }, {
      "animal" => {
        "april" => 0, "august" => 0, "december" => 0, "february" => 0, "january" => 1, "july" => 0,
        "june" => 0, "march" => 0, "may" => 1, "november" => 0, "october" => 0, "september" => 1
      }
    }])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Animal, "#animal_type" do

  it "belongs to an animal type" do
    animal_type = AnimalType.new
    animal = Animal.new :animal_type => animal_type

    expect(animal.animal_type).to eq(animal_type)
  end

  it "returns a readonly animal type" do
    animal = Animal.gen
    expect(animal.reload.animal_type).to be_readonly
  end
end

describe Animal, "#animal_status" do

  it "belongs to an animal status" do
    animal_status = AnimalStatus.new
    animal = Animal.new :animal_status => animal_status

    expect(animal.animal_status).to eq(animal_status)
  end

  it "returns a readonly animal status" do
    animal = Animal.gen
    expect(animal.reload.animal_status).to be_readonly
  end
end

describe Animal, "#accommodation" do

  it "belongs to an accommodation" do
    accommodation = Accommodation.new
    animal = Animal.new :accommodation => accommodation

    expect(animal.accommodation).to eq(accommodation)
  end
end

describe Animal, "#shelter" do

  it "belongs to an shelter" do
    shelter = Shelter.new
    animal = Animal.new :shelter => shelter

    expect(animal.shelter).to eq(shelter)
  end
end

describe Animal, "#placements" do

  before do
    @animal = Animal.gen
    @placement1 = Placement.gen :animal => @animal
    @placement2 = Placement.gen :animal => @animal
  end

  it "returns a list of placements" do
    expect(@animal.placements.count).to eq(2)
    expect(@animal.placements).to match_array([@placement1, @placement2])
  end

  it "destroy all placements associated to the animal" do
    expect(@animal.placements.count).to eq(2)
    @animal.destroy
    expect(@animal.placements.count).to eq(0)
  end
end

describe Animal, "#notes" do

  before do
    @animal = Animal.gen
    @note1 = Note.gen :notable => @animal
    @note2 = Note.gen :notable => @animal
  end

  it "returns a list of notes" do
    expect(@animal.notes.count).to eq(2)
    expect(@animal.notes).to match_array([@note1, @note2])
  end

  it "destroy all notes associated to the animal" do
    expect(@animal.notes.count).to eq(2)
    @animal.destroy
    expect(@animal.notes.count).to eq(0)
  end
end

describe Animal, "#alerts" do

  before do
    @animal = Animal.gen
    @alert1 = Alert.gen :alertable => @animal
    @alert2 = Alert.gen :alertable => @animal
  end

  it "returns a list of alerts" do
    expect(@animal.alerts.count).to eq(2)
    expect(@animal.alerts).to match_array([@alert1, @alert2])
  end

  it "destroy all alerts associated to the animal" do
    expect(@animal.alerts.count).to eq(2)
    @animal.destroy
    expect(@animal.alerts.count).to eq(0)
  end
end

describe Animal, "#tasks" do

  before do
    @animal = Animal.gen
    @task1 = Task.gen :taskable => @animal
    @task2 = Task.gen :taskable => @animal
  end

  it "returns a list of tasks" do
    expect(@animal.tasks.count).to eq(2)
    expect(@animal.tasks).to match_array([@task1, @task2])
  end

  it "destroy all tasks associated to the animal" do
    expect(@animal.tasks.count).to eq(2)
    @animal.destroy
    expect(@animal.tasks.count).to eq(0)
  end
end

describe Animal, "#transfers" do

  before do
    @animal = Animal.gen
    @transfer1 = Transfer.gen :animal => @animal
    @transfer2 = Transfer.gen :animal => @animal
  end

  it "returns a list of transfers" do
    expect(@animal.transfers.count).to eq(2)
    expect(@animal.transfers).to match_array([@transfer1, @transfer2])
  end

  it "destroy all transfers associated to the animal" do
    expect(@animal.transfers.count).to eq(2)
    @animal.destroy
    expect(@animal.transfers.count).to eq(0)
  end
end

describe Animal, "#status_histories" do

  before do
    @animal = Animal.gen
    @status_history1 = StatusHistory.gen :animal => @animal
    @status_history2 = StatusHistory.gen :animal => @animal
  end

  it "returns a list of status_histories" do
    expect(@animal.status_histories.count).to eq(3)
    expect(@animal.status_histories).to include(@status_history1, @status_history2)
  end

  it "destroy all status_histories associated to the animal" do
    expect(@animal.status_histories.count).to eq(3)
    @animal.destroy
    expect(@animal.status_histories.count).to eq(0)
  end
end

describe Animal, "#photos" do

  before do
    @animal = Animal.gen
    @photo1 = Photo.gen :attachable => @animal
    @photo2 = Photo.gen :attachable => @animal
  end

  it "returns a list of photos" do
    expect(@animal.photos.count).to eq(2)
    expect(@animal.photos).to match_array([@photo1, @photo2])
  end

  it "destroy all photos associated to the animal" do
    expect(@animal.photos.count).to eq(2)
    @animal.destroy
    expect(@animal.photos.count).to eq(0)
  end
end

describe Animal, "#full_breed" do

  it "returns the full breed when only primary breed" do
    animal = Animal.new :primary_breed => "Labrador Retriever"
    expect(animal.full_breed).to eq("Labrador Retriever")
  end

  it "returns the full breed when primary breed and is a mix breed" do
    animal = Animal.new(
      :primary_breed => "Labrador Retriever",
      :secondary_breed => "",
      :is_mix_breed => true
    )
    expect(animal.full_breed).to eq("Labrador Retriever Mix")
  end

  it "returns the full breed when primary breed and is a mix breed with secondary breed" do
    animal = Animal.new(
      :primary_breed => "Labrador Retriever",
      :secondary_breed => "Border Collie",
      :is_mix_breed => true
    )
    expect(animal.full_breed).to eq("Labrador Retriever & Border Collie Mix")
  end
end

describe Animal, "#stopped?" do

  it "returns true if the animal has special needs" do
    animal1 = Animal.new :has_special_needs => true
    animal2 = Animal.new

    expect(animal1.special_needs?).to eq(true)
    expect(animal2.special_needs?).to eq(false)
  end
end

describe Animal, "#mix_breed?" do

  it "returns true if the animal is a mix breed" do
    animal1 = Animal.new :is_mix_breed => true
    animal2 = Animal.new :is_mix_breed => false

    expect(animal1.mix_breed?).to eq(true)
    expect(animal2.mix_breed?).to eq(false)
  end
end

describe Animal, "#sterilized?" do

  it "returns true if the animal is sterilized" do
    animal1 = Animal.new :is_sterilized => true
    animal2 = Animal.new :is_sterilized => false

    expect(animal1.sterilized?).to eq(true)
    expect(animal2.sterilized?).to eq(false)
  end
end

