require 'rails_helper'

describe DataExport::AccommodationPresenter do

  before do
    @accommodation = Accommodation.gen
  end

  describe "#id" do
    it "returns the accommodation id" do
      presenter = DataExport::AccommodationPresenter.new(@accommodation)
      expect(presenter.id).to eq(@accommodation.id)
    end
  end

  describe "#name" do
    it "returns the accommodation name" do
      presenter = DataExport::AccommodationPresenter.new(@accommodation)
      expect(presenter.name).to eq(@accommodation.name)
    end
  end

  describe "#max_capacity" do
    it "returns the accommodation max_capacity" do
      presenter = DataExport::AccommodationPresenter.new(@accommodation)
      expect(presenter.max_capacity).to eq(@accommodation.max_capacity)
    end
  end

  describe "#animal_type" do
    it "returns the animal type name" do
      type = AnimalType.gen :name => "doggie"
      @accommodation.update_column(:animal_type_id, type.id)
      presenter = DataExport::AccommodationPresenter.new(@accommodation)
      expect(presenter.animal_type).to eq("doggie")
    end
  end

  describe "#location_name" do
    it "returns the location name" do
      location = Location.gen :name => "doggie wing"
      @accommodation.update_column(:location_id, location.id)
      presenter = DataExport::AccommodationPresenter.new(@accommodation)
      expect(presenter.location_name).to eq("doggie wing")
    end
  end

  describe "#create_at" do
    it "returns the accommodation created_at timestamp" do
      presenter = DataExport::AccommodationPresenter.new(@accommodation)
      expect(presenter.created_at).to eq(@accommodation.created_at)
    end
  end

  describe "#updated_at" do
    it "returns the accommodation updated_at timestamp" do
      presenter = DataExport::AccommodationPresenter.new(@accommodation)
      expect(presenter.updated_at).to eq(@accommodation.updated_at)
    end
  end

  describe "#to_csv" do

    it "returns the accommodation in a csv row format" do
      presenter = DataExport::AccommodationPresenter.new(@accommodation)
      expect(presenter.to_csv).to eq([
        presenter.id,
        presenter.name,
        presenter.max_capacity,
        presenter.animal_type,
        presenter.location_name,
        presenter.created_at,
        presenter.updated_at
      ])
    end
  end

  describe ".csv_header" do
    it "returns the csv header" do
      expect(
        DataExport::AccommodationPresenter.csv_header

      ).to eq(
        ["Id", "Name", "Max Capacity", "Animal Type", "Location Name", "Created At", "Updated At"]
      )
    end
  end

  describe ".as_csv" do
    it "returns a collection in csv format" do
      accommodation1 = Accommodation.gen
      accommodation2 = Accommodation.gen
      csv = []

      DataExport::AccommodationPresenter.as_csv([accommodation1,accommodation2], csv)

      expect(csv).to match_array([
        DataExport::AccommodationPresenter.csv_header,
        DataExport::AccommodationPresenter.new(accommodation1).to_csv,
        DataExport::AccommodationPresenter.new(accommodation2).to_csv
      ])
    end
  end
end


