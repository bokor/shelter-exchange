require 'spec_helper'

describe Animal::ExportPresenter do

  before do
    @animal = Animal.gen
  end

  describe "#id" do
    it "returns the animal id" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.id).to eq(@animal.id)
    end
  end

  describe "#name" do
    it "returns the animal name" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.name).to eq(@animal.name)
    end
  end

  describe "#type" do
    it "returns the animal type name" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.type).to eq(@animal.animal_type.name)
    end
  end

  describe "#status" do
    it "returns the animal status name" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.status).to eq(@animal.animal_status.name)
    end
  end

  describe "#mixed_breed" do
    it "returns Y if animal mixed breed" do
      @animal.update_column(:is_mix_breed, true)
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.mixed_breed).to eq("Y")
    end

    it "returns N if animal not mixed breed" do
      @animal.update_column(:is_mix_breed, false)
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.mixed_breed).to eq("N")
    end
  end

  describe "#primary_breed" do
    it "returns the animal primary breed" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.primary_breed).to eq(@animal.primary_breed)
    end
  end

  describe "#secondary_breed" do
    it "returns animal secondary_breed if mixed breed" do
      @animal.update_column(:is_mix_breed, true)
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.secondary_breed).to eq(@animal.secondary_breed)
    end

    it "returns animal secondary_breed if not mixed breed" do
      @animal.update_column(:is_mix_breed, false)
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.secondary_breed).to be_nil
    end
  end

  describe "#microchip" do
    it "returns the animal microchip" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.microchip).to eq(@animal.microchip)
    end
  end

  describe "#sterilized" do
    it "returns Y if animal sterilized" do
      @animal.update_column(:is_sterilized, true)
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.sterilized).to eq("Y")
    end

    it "returns N if animal not sterilized" do
      @animal.update_column(:is_sterilized, false)
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.sterilized).to eq("N")
    end
  end

  describe "#sex" do
    it "returns the animal sex" do
      @animal.update_column(:sex, "male")
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.sex).to eq("Male")
    end
  end

  describe "#size" do
    it "returns animal size when equal the size constant" do
      @animal.update_column(:size, "L")
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.size).to eq("Large")
    end

    it "returns N/A if animal size on in the constant" do
      @animal.update_column(:size, "super tiny")
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.size).to eq("N/A")
    end
  end

  describe "#color" do
    it "returns the animal color" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.color).to eq(@animal.color)
    end
  end

  describe "#weight" do
    it "returns the animal weight" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.weight).to eq(@animal.weight)
    end
  end

  describe "#age" do
    it "returns the animal age when in age constant" do
      @animal.update_column(:age, "baby")
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.age).to eq("Baby")
    end

    it "returns nothing when animal age not in constant" do
      @animal.update_column(:age, nil)
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.age).to be_nil
    end
  end

  describe "#date_of_birth" do
    it "returns the animal date_of_birth" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.date_of_birth).to eq(@animal.date_of_birth)
    end
  end

  describe "#arrival_date" do
    it "returns the animal arrival_date" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.arrival_date).to eq(@animal.arrival_date)
    end
  end

  describe "#special_needs" do
    it "returns Y if animal special_needs" do
      @animal.update_column(:has_special_needs, true)
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.special_needs).to eq("Y")
    end

    it "returns N if animal not special_needs" do
      @animal.update_column(:has_special_needs, false)
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.special_needs).to eq("N")
    end
  end

  describe "#special_needs_description" do
    it "returns the animal special_needs" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.special_needs_description).to eq(@animal.special_needs)
    end
  end

  describe "#description" do
    it "returns generic description when blank" do
      @animal.update_column(:description, nil)
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.description).to eq("No description provided")
    end

    it "returns formatted description" do
      @animal.update_column(:description, "this is cool.  www.shelterexchange.org")
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.description).to eq("<p>this is cool.  <a href=\"http://www.shelterexchange.org\" target=\"_blank\">www.shelterexchange.org</a></p>")
    end
  end

  describe "#photos" do
    it "returns an array of 4 nils when no photos" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.photos).to match_array([nil, nil, nil, nil])
    end

    it "returns an array of 2 images and 2 nils" do
      photo1 = Photo.gen :attachable => @animal
      photo2 = Photo.gen :attachable => @animal
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.photos).to match_array([
        photo1.image.url,
        photo2.image.url,
        nil,
        nil
      ])
    end
  end

  describe "#video_url" do
    it "returns the animal video_url" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.video_url).to eq(@animal.video_url)
    end
  end

  describe "#accommodation" do
    it "returns blank string when no accommodation" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.accommodation).to eq("")
    end

    it "returns accommodation name when one exists" do
      accommodation = Accommodation.gen :name => "crate1"
      @animal.update_column(:accommodation_id, accommodation.id)
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.accommodation).to eq("crate1")
    end
  end

  describe "#location" do
    it "returns blank string when no location" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.location).to eq("")
    end

    it "returns location name when one exists" do
      location = Location.gen :name => "puppy room"
      accommodation = Accommodation.gen :name => "crate1", :location => location
      @animal.update_column(:accommodation_id, accommodation.id)

      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.location).to eq("puppy room")
    end
  end

  describe "#to_csv" do
    it "returns the animal in a csv row format" do
      presenter = Animal::ExportPresenter.new(@animal)
      expect(presenter.to_csv).to eq([
        presenter.id,
        presenter.name,
        presenter.type,
        presenter.status,
        presenter.mixed_breed,
        presenter.primary_breed,
        presenter.secondary_breed,
        presenter.microchip,
        presenter.sterilized,
        presenter.sex,
        presenter.size,
        presenter.color,
        presenter.weight,
        presenter.age,
        presenter.date_of_birth,
        presenter.arrival_date,
        presenter.special_needs,
        presenter.special_needs_description,
        presenter.description,
        presenter.photos,
        presenter.video_url,
        presenter.accommodation,
        presenter.location
      ].flatten)
    end
  end

  describe ".csv_header" do
    it "returns the csv header" do
      expect(
        Animal::ExportPresenter.csv_header
      ).to eq([
        "Id",
        "Name",
        "Type",
        "Status",
        "Mixed Breed",
        "Primary Breed",
        "Secondary Breed",
        "Microchip",
        "Sterilized",
        "Sex",
        "Size",
        "Color",
        "Weight",
        "Age",
        "Date of Birth",
        "Arrival Date",
        "Has Special Needs",
        "Special Needs Description",
        "Description",
        "Photo1",
        "Photo2",
        "Photo3",
        "Photo4",
        "Video",
        "Accommodation",
        "Location"
      ])
    end
  end

  describe ".as_csv" do
    it "returns a collection in csv format" do
      animal1 = Animal.gen
      animal2 = Animal.gen
      csv = []

      Animal::ExportPresenter.as_csv([animal1,animal2], csv)

      expect(csv).to match_array([
        Animal::ExportPresenter.csv_header,
        Animal::ExportPresenter.new(animal1).to_csv,
        Animal::ExportPresenter.new(animal2).to_csv
      ])
    end
  end
end

