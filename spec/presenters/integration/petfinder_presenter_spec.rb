require 'spec_helper'

describe Integration::PetfinderPresenter do

  before do
    @animal = Animal.gen
  end

  describe "#id" do
    it "returns the animal id" do
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.id).to eq(@animal.id)
    end
  end

  describe "#name" do
    it "returns the animal name" do
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.name).to eq(@animal.name)
    end
  end

  describe "#breed" do

    it "returns the animals primary breed" do
      @animal.update_column(:primary_breed, "Lab")
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.breed).to eq("Lab")
    end

    it "returns a mapped breed" do
      @animal.update_column(:primary_breed, "American Foxhound")
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.breed).to eq("Foxhound")
    end
  end

  describe "#breed2" do

    it "returns nothing when not mixed breed" do
      @animal.update_column(:secondary_breed, "Lab")
      @animal.update_column(:is_mix_breed, false)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.breed2).to be_nil
    end

    it "returns the animals primary breed" do
      @animal.update_column(:secondary_breed, "Lab")
      @animal.update_column(:is_mix_breed, true)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.breed2).to eq("Lab")
    end

    it "returns a mapped breed" do
      @animal.update_column(:secondary_breed, "American Foxhound")
      @animal.update_column(:is_mix_breed, true)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.breed2).to eq("Foxhound")
    end
  end

  describe "#sex" do

    it "returns M for male" do
      @animal.update_column(:sex, "male")
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.sex).to eq("M")
    end

    it "returns F for female" do
      @animal.update_column(:sex, "female")
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.sex).to eq("F")
    end
  end

  describe "#size" do

    it "returns nil when no size" do
      @animal.update_column(:size, nil)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.size).to be_nil
    end

    it "returns animal size" do
      @animal.update_column(:size, "super tiny")
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.size).to eq("super tiny")
    end
  end

  describe "#age" do

    it "returns nil when no age" do
      @animal.update_column(:age, nil)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.age).to be_nil
    end

    it "returns animal age" do
      @animal.update_column(:age, "baby")
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.age).to eq("Baby")
    end
  end

  describe "#description" do

    it "returns generic description when blank" do
      @animal.update_column(:description, nil)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.description).to eq("<p>No description provided<br>#{@animal.name}, #{@animal.full_breed} has been shared from Shelter Exchange - http://www.shelterexchange.org.</p>")
    end

    it "returns formatted description" do
      @animal.update_column(:description, "this is cool.  www.example.org")
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.description).to eq("<p>this is cool.  www.example.org<br>#{@animal.name}, #{@animal.full_breed} has been shared from Shelter Exchange - http://www.shelterexchange.org.</p>")
    end

    it "returns formatted description with carriage returns" do
      @animal.update_column(:description, "hi\n bye\n\r")
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.description).to eq("<p>hi<br><br /> bye</p><br><br><p><br>#{@animal.name}, #{@animal.full_breed} has been shared from Shelter Exchange - http://www.shelterexchange.org.</p>")
    end
  end

  describe "#type" do

    it "returns the animal type name" do
      type = AnimalType.gen :name => "doggie"
      @animal.update_column(:animal_type_id, type.id)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.type).to eq("doggie")
    end

    it "returns a mapped name for reptile" do
      @animal.update_column(:primary_breed, "Chameleon")
      @animal.update_column(:animal_type_id, AnimalType::TYPES[:reptile])
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.type).to eq("Scales, Fins & Other")
    end

    it "returns a mapped name for other" do
      @animal.update_column(:primary_breed, "Pig")
      @animal.update_column(:animal_type_id, AnimalType::TYPES[:other])
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.type).to eq("Barnyard")
    end
  end

  describe "#status" do

    it "returns nil when status does not match" do
      @animal.update_column(:animal_status_id, AnimalStatus::STATUSES[:adoption])
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.status).to be_nil
    end

    it "returns A for available for adoption" do
      @animal.update_column(:animal_status_id, AnimalStatus::STATUSES[:available_for_adoption])
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.status).to eq("A")
    end

    it "returns P for adoption pending" do
      @animal.update_column(:animal_status_id, AnimalStatus::STATUSES[:adoption_pending])
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.status).to eq("P")
    end
  end

  describe "#altered" do

    it "returns nil when not sterilized" do
      @animal.update_column(:is_sterilized, false)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.altered).to be_nil
    end

    it "returns 1 if animal sterilized" do
      @animal.update_column(:is_sterilized, true)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.altered).to eq(1)
    end
  end

  describe "#mix" do

    it "returns nil when not mix" do
      @animal.update_column(:is_mix_breed, false)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.mix).to be_nil
    end

    it "returns 1 if animal mix" do
      @animal.update_column(:is_mix_breed, true)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.mix).to eq(1)
    end
  end

  describe "#special_needs" do

    it "returns nil when not mix" do
      @animal.update_column(:has_special_needs, false)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.special_needs).to be_nil
    end

    it "returns 1 if animal mix" do
      @animal.update_column(:has_special_needs, true)
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.special_needs).to eq(1)
    end
  end

  describe "#photos" do

    it "returns an array of nil photos" do
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.photos).to match_array([nil, nil, nil])
    end

    it "returns an max array of 3 photos" do
      Photo.gen :attachable => @animal
      Photo.gen :attachable => @animal
      Photo.gen :attachable => @animal
      Photo.gen :attachable => @animal

      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.photos).to match_array([
        "#{presenter.id}-1.jpg",
        "#{presenter.id}-2.jpg",
        "#{presenter.id}-3.jpg"
      ])
    end

    it "returns an array of 2 images and 1 nil" do
      Photo.gen :attachable => @animal
      Photo.gen :attachable => @animal

      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.photos).to match_array([
        "#{presenter.id}-1.jpg",
        "#{presenter.id}-2.jpg",
        nil
      ])
    end
  end

  describe "#to_csv" do

    it "returns the animal in a csv row format" do
      presenter = Integration::PetfinderPresenter.new(@animal)
      expect(presenter.to_csv).to eq([
        presenter.id,
        '',
        presenter.name,
        presenter.breed,
        presenter.breed2,
        presenter.sex,
        presenter.size,
        presenter.age,
        presenter.description,
        presenter.type,
        presenter.status,
        '',
        presenter.altered,
        '', '', '', '', '',
        presenter.special_needs,
        presenter.mix
      ].concat(presenter.photos))
    end
  end

  describe ".csv_header" do
    it "returns the csv header" do
      expect(
        Integration::PetfinderPresenter.csv_header
      ).to eq([
        "ID",
        "Internal",
        "AnimalName",
        "PrimaryBreed",
        "SecondaryBreed",
        "Sex",
        "Size",
        "Age",
        "Desc",
        "Type",
        "Status",
        "Shots",
        "Altered",
        "NoDogs","NoCats","NoKids","Housetrained","Declawed",
        "specialNeeds",
        "Mix",
        "photo1",
        "photo2",
        "photo3"
      ])
    end
  end

  describe ".as_csv" do
    it "returns a collection in csv format" do
      animal1 = Animal.gen
      animal2 = Animal.gen
      csv = []

      Integration::PetfinderPresenter.as_csv([animal1,animal2], csv)

      expect(csv).to match_array([
        Integration::PetfinderPresenter.csv_header,
        Integration::PetfinderPresenter.new(animal1).to_csv,
        Integration::PetfinderPresenter.new(animal2).to_csv
      ])
    end
  end
end

