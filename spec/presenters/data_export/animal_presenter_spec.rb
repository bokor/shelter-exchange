require 'rails_helper'

describe DataExport::AnimalPresenter do

  before do
    @status = AnimalStatus.gen :name => "cuteness"
    @type = AnimalType.gen :name => "doggie"
    @animal = Animal.gen :animal_type => @type, :animal_status => @status
  end

  describe "#id" do
    it "returns the animal id" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.id).to eq(@animal.id)
    end
  end

  describe "#microchip" do
    it "returns the animal microchip" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.microchip).to eq(@animal.microchip)
    end
  end

  describe "#name" do
    it "returns the animal name" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.name).to eq(@animal.name)
    end
  end

  describe "#status" do
    it "returns the name of the animal status" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.status).to eq(@status.name)
    end
  end

  describe "#type" do
    it "returns the name of the animal type" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.type).to eq(@type.name)
    end
  end

  describe "#primary_breed" do
    it "returns the animal primary_breed" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.primary_breed).to eq(@animal.primary_breed)
    end
  end

  describe "#secondary_breed" do
    it "returns the animal secondary_breed" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.secondary_breed).to eq(@animal.secondary_breed)
    end
  end

  describe "#mixed_breed" do
    it "returns yes when the animal is a mixed breed" do
      @animal.update_column(:is_mix_breed, true)
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.mixed_breed).to eq("Yes")
    end

    it "returns no when the animal is not a mixed breed" do
      @animal.update_column(:is_mix_breed, false)
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.mixed_breed).to eq("No")
    end
  end

  describe "#sterilized" do
    it "returns yes when the animal is sterilized" do
      @animal.update_column(:is_sterilized, true)
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.sterilized).to eq("Yes")
    end

    it "returns no when the animal is not sterilized" do
      @animal.update_column(:is_sterilized, false)
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.sterilized).to eq("No")
    end
  end

  describe "#sex" do
    it "returns the animal sex" do
      @animal.update_column(:sex, "female")
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.sex).to eq("Female")
    end
  end

  describe "#date_of_birth" do
    it "returns the animal date_of_birth" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.date_of_birth).to eq(@animal.date_of_birth)
    end
  end

  describe "#color" do
    it "returns the animal color" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.color).to eq(@animal.color)
    end
  end

  describe "#weight" do
    it "returns the animal weight" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.weight).to eq(@animal.weight)
    end
  end

  describe "#size" do
    it "returns the animal size" do
      @animal.update_column(:size, "S")
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.size).to eq("Small")
    end
  end

  describe "#age" do
    it "returns the animal age" do
      @animal.update_column(:age, "baby")
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.age).to eq("Baby")
    end
  end

  describe "#special_needs" do
    it "returns yes when the animal has special needs" do
      @animal.update_column(:has_special_needs, true)
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.special_needs).to eq("Yes")
    end

    it "returns no when the animal does not have special needs" do
      @animal.update_column(:has_special_needs, false)
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.special_needs).to eq("No")
    end
  end

  describe "#special_needs_description" do
    it "returns the animal special needs description" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.special_needs_description).to eq(@animal.special_needs)
    end
  end

  describe "#status_date" do
    it "returns the animal status date" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.status_date).to eq(@animal.status_change_date)
    end
  end

  describe "#arrival_date" do
    it "returns the animal arrival date" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.arrival_date).to eq(@animal.arrival_date)
    end
  end

  describe "#hold_time" do
    it "returns the animal hold time" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.hold_time).to eq(@animal.hold_time)
    end
  end

  describe "#euthanasia_date" do
    it "returns the animal euthanasia date" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.euthanasia_date).to eq(@animal.euthanasia_date)
    end
  end

  describe "#accommodation_id" do
    it "returns the animal accommodation id" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.accommodation_id).to eq(@animal.accommodation_id)
    end
  end

  describe "#video_url" do
    it "returns the animal video url" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.video_url).to eq(@animal.video_url)
    end
  end

  describe "#description" do
    it "returns the animal description" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.description).to eq(@animal.description)
    end
  end

  describe "#create_at" do
    it "returns the animal created_at timestamp" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.created_at).to eq(@animal.created_at)
    end
  end

  describe "#updated_at" do
    it "returns the animal updated_at timestamp" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.updated_at).to eq(@animal.updated_at)
    end
  end

  describe "#to_csv" do

    it "returns the animal in a csv row format" do
      presenter = DataExport::AnimalPresenter.new(@animal)
      expect(presenter.to_csv).to eq([
        presenter.id,
        presenter.microchip,
        presenter.name,
        presenter.status,
        presenter.type,
        presenter.primary_breed,
        presenter.secondary_breed,
        presenter.mixed_breed,
        presenter.sterilized,
        presenter.sex,
        presenter.date_of_birth,
        presenter.color,
        presenter.weight,
        presenter.size,
        presenter.age,
        presenter.special_needs,
        presenter.special_needs_description,
        presenter.status_date,
        presenter.arrival_date,
        presenter.hold_time,
        presenter.euthanasia_date,
        presenter.accommodation_id,
        presenter.video_url,
        presenter.description,
        presenter.created_at,
        presenter.updated_at
      ])
    end
  end

  describe ".csv_header" do
    it "returns the csv header" do
      expect(
        DataExport::AnimalPresenter.csv_header
      ).to eq([
        "Id",
        "Microchip",
        "Name",
        "Status",
        "Type",
        "Primary Breed",
        "Secondary Breed",
        "Mixed Breed",
        "Sterilized",
        "Sex",
        "Date of Birth",
        "Color",
        "Weight",
        "Size",
        "Age",
        "Special Needs",
        "Special Needs Description",
        "Status Date",
        "Arrival Date",
        "Hold Time",
        "Euthanasia Date",
        "Accommodation Id",
        "Video URL",
        "Description",
        "Created At",
        "Updated At"
      ])
    end
  end

  describe ".as_csv" do
    it "returns a collection in csv format" do
      animal1 = Animal.gen
      animal2 = Animal.gen
      csv = []

      DataExport::AnimalPresenter.as_csv([animal1,animal2], csv)

      expect(csv).to match_array([
        DataExport::AnimalPresenter.csv_header,
        DataExport::AnimalPresenter.new(animal1).to_csv,
        DataExport::AnimalPresenter.new(animal2).to_csv
      ])
    end
  end
end


