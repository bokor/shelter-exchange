require 'rails_helper'

describe DataExport::PhotoPresenter do

  before do
    file1 = File.open("#{Rails.root}/spec/data/images/photo.jpg")

    @animal = Animal.gen
    @photo = Photo.gen :image => file1, :attachable => @animal
  end

  describe "#id" do
    it "returns the photo id" do
      presenter = DataExport::PhotoPresenter.new(@photo)
      expect(presenter.id).to eq(@photo.id)
    end
  end

  describe "#image" do
    it "returns the photo image" do
      presenter = DataExport::PhotoPresenter.new(@photo)
      expect(presenter.image).to eq("photos/photo.jpg")
    end
  end

  describe "#animal_id" do
   it "returns the photo animal_id" do
      presenter = DataExport::PhotoPresenter.new(@photo)
      expect(presenter.animal_id).to eq(@photo.attachable_id)
    end
  end

  describe "#create_at" do
    it "returns the photo created_at timestamp" do
      presenter = DataExport::PhotoPresenter.new(@photo)
      expect(presenter.created_at).to eq(@photo.created_at)
    end
  end

  describe "#updated_at" do
    it "returns the photo updated_at timestamp" do
      presenter = DataExport::PhotoPresenter.new(@photo)
      expect(presenter.updated_at).to eq(@photo.updated_at)
    end
  end

  describe "#to_csv" do

    it "returns the photo in a csv row format" do
      presenter = DataExport::PhotoPresenter.new(@photo)
      expect(presenter.to_csv).to eq([
        presenter.id,
        presenter.image,
        presenter.animal_id,
        presenter.created_at,
        presenter.updated_at
      ])
    end
  end

  describe ".csv_header" do
    it "returns the csv header" do
      expect(
        DataExport::PhotoPresenter.csv_header

      ).to eq(["Id", "Image", "Animal Id", "Created At", "Updated At"])
    end
  end

  describe ".as_csv" do
    it "returns a collection in csv format" do
      photo1 = Photo.gen
      photo2 = Photo.gen
      csv = []

      DataExport::PhotoPresenter.as_csv([photo1,photo2], csv)

      expect(csv).to match_array([
        DataExport::PhotoPresenter.csv_header,
        DataExport::PhotoPresenter.new(photo1).to_csv,
        DataExport::PhotoPresenter.new(photo2).to_csv
      ])
    end
  end
end


