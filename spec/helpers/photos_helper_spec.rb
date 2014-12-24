require "rails_helper"

describe PhotosHelper, "#setup_photos" do

  it "returns the main photo" do
    animal = Animal.gen
    Photo.gen(:attachable => animal, :is_main_photo => true)
    Photo.gen(:attachable => animal, :is_main_photo => false)
    Photo.gen(:attachable => animal, :is_main_photo => false)

    expect{
      helper.setup_photos(animal)
    }.to change(animal.photos, :size).by(-2)
  end

  it "returns the animal with a main photo built" do
    animal = Animal.gen
    Photo.gen(:attachable => animal, :is_main_photo => false)
    Photo.gen(:attachable => animal, :is_main_photo => false)

    expect{
      helper.setup_photos(animal)
    }.to change(animal.photos, :size).by(-1)

    photo = animal.photos.first
    expect(photo.is_main_photo).to be_truthy
  end
end

describe PhotosHelper, "#polymorphic_photo_url" do

  context "with a photo" do

    it "returns the thumb photo image url" do
      animal = Animal.gen
      photo = Photo.gen :attachable => animal

      expect(
        helper.polymorphic_photo_url(photo, :thumb)
      ).to eq("https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{animal.id}/thumb/#{photo.guid}.jpg")
    end

    it "returns the original photo image url without a version" do
      animal = Animal.gen
      photo = Photo.gen :attachable => animal

      expect(
        helper.polymorphic_photo_url(photo, nil)
      ).to eq("https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{animal.id}/original/#{photo.guid}.jpg")
    end
  end

  context "without a photo" do

    it "returns the original default photo" do
      expect(
        helper.polymorphic_photo_url(nil, :original)
      ).to eq("/assets/default_original_photo.jpg")
    end

    it "returns a thumb version of the default photo" do
      expect(
        helper.polymorphic_photo_url(nil, :thumb)
      ).to eq("/assets/default_thumb_photo.jpg")
    end
  end
end

