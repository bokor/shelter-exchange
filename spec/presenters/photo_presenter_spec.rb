require 'rails_helper'

describe PhotoPresenter do

  before do
    file1 = File.open("#{Rails.root}/spec/data/images/photo.jpg")
    file2 = File.open("#{Rails.root}/spec/data/images/adoption_contract.jpg")
    file3 = File.open("#{Rails.root}/spec/data/images/another_photo.jpg")

    @animal = Animal.gen
    @photo1 = Photo.gen :image => file1, :attachable => @animal, :is_main_photo => true
    @photo2 = Photo.gen :image => file2, :attachable => @animal, :is_main_photo => false
    @photo3 = Photo.gen :image => file3, :attachable => @animal, :is_main_photo => false
  end

  describe "#to_uploader" do
    it "returns an uploader array representing the photo" do
      presenter = PhotoPresenter.new(@photo1)
      expect(presenter.to_uploader).to match_array([
        {
          "name" => "photo.jpg",
          "url" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{@photo1.image.filename}",
          "thumbnail_url" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/thumb/#{@photo1.image.filename}",
          "delete_url" => "/photos/#{@photo1.id}",
          "delete_type" => "DELETE"
        }
      ])
    end
  end

  describe "#to_gallery" do
    it "returns a gallery array representing the photo" do
      presenter = PhotoPresenter.new(@photo1)
      expect(presenter.to_gallery).to match_array([
        {
          :thumb => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/thumb/#{@photo1.image.filename}",
          :image => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/large/#{@photo1.image.filename}",
          :big => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{@photo1.image.filename}",
          :title => @animal.name,
          :description => @animal.full_breed
        }
      ])
    end
  end

  describe ".to_blank_gallery" do
    it "returns an empty gallery array representing no photos" do
      expect(PhotoPresenter.to_blank_gallery).to match_array([
        {
          :thumb => "/assets/default_large_photo.jpg",
          :image => "/assets/default_large_photo.jpg",
          :big => "/assets/default_large_photo.jpg",
          :title => "No photo provided"
        }
      ])
    end
  end

  describe ".as_uploader_collection" do
    it "returns multiple documents to uploader json" do
      json = PhotoPresenter.as_uploader_collection([@photo1, @photo2, @photo3])

      expect(MultiJson.load(json)).to match_array([
        {
          "name" => "adoption_contract.jpg",
          "url" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{@photo2.image.filename}",
          "thumbnail_url" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/thumb/#{@photo2.image.filename}",
          "delete_url" => "/photos/#{@photo2.id}",
          "delete_type" => "DELETE"
        }, {
          "name" => "another_photo.jpg",
          "url" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{@photo3.image.filename}",
          "thumbnail_url" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/thumb/#{@photo3.image.filename}",
          "delete_url" => "/photos/#{@photo3.id}",
          "delete_type" => "DELETE"
        }
      ])
    end
  end

  describe ".as_gallery_collection" do

    it "returns json when photos are blank" do
      json = PhotoPresenter.as_gallery_collection([])

      expect(MultiJson.load(json)).to match_array([
        {
          "thumb" => "/assets/default_large_photo.jpg",
          "image" => "/assets/default_large_photo.jpg",
          "big" => "/assets/default_large_photo.jpg",
          "title" => "No photo provided"
        }
      ])
    end

    it "returns json for all photos" do
      json = PhotoPresenter.as_gallery_collection([@photo1, @photo2, @photo3])

      expect(MultiJson.load(json)).to match_array([
        {
          "thumb" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/thumb/#{@photo1.image.filename}",
          "image" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/large/#{@photo1.image.filename}",
          "big" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{@photo1.image.filename}",
          "title" => @animal.name,
          "description" => @animal.full_breed
        }, {
          "thumb" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/thumb/#{@photo2.image.filename}",
          "image" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/large/#{@photo2.image.filename}",
          "big" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{@photo2.image.filename}",
          "title" => @animal.name,
          "description" => @animal.full_breed
        }, {
          "thumb" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/thumb/#{@photo3.image.filename}",
          "image" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/large/#{@photo3.image.filename}",
          "big" => "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{@photo3.image.filename}",
          "title" => @animal.name,
          "description" => @animal.full_breed
        }
      ])
    end
  end
end

