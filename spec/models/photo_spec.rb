require 'rails_helper'

describe Photo do

  it_should_behave_like Uploadable

  it "has a default scope" do
    expect(Photo.scoped.to_sql).to eq(Photo.order('photos.is_main_photo DESC, photos.created_at DESC').to_sql)
  end

  it "validates the max number of additional photos for an attachable" do
    note = Note.new
    Photo.gen(:attachable => note, :is_main_photo => false)
    Photo.gen(:attachable => note, :is_main_photo => false)
    Photo.gen(:attachable => note, :is_main_photo => false)
    Photo.gen(:attachable => note, :is_main_photo => false)

    photo = Photo.gen(:attachable => note)

    expect(photo.valid?).to be_falsey
    expect(photo.errors[:base].size).to eq(1)
    expect(photo.errors[:base]).to match_array(["Max number of files exceeded"])
  end

  context "Before Create" do

    describe "#set_original_name" do
      it "sets the original name" do
        file = File.open("#{Rails.root}/spec/data/images/photo.jpg")
        photo = Photo.gen(:image => file)
        expect(photo.original_name).to eq("photo.jpg")
      end
    end
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Photo, ".main_photo" do

  it "returns only the main photos" do
    photo1 = Photo.gen(:is_main_photo => true)
    photo2 = Photo.gen(:is_main_photo => true)
    Photo.gen(:is_main_photo => false)
    Photo.gen(:is_main_photo => false)

    photos = Photo.main_photo
    expect(photos).to match_array([photo1, photo2])
  end
end

describe Photo, ".not_main_photo" do

  it "returns only the main photos" do
    photo1 = Photo.gen(:is_main_photo => false)
    photo2 = Photo.gen(:is_main_photo => false)
    Photo.gen(:is_main_photo => true)
    Photo.gen(:is_main_photo => true)

    photos = Photo.not_main_photo
    expect(photos).to match_array([photo1, photo2])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Photo, "#attachable" do

  it "belongs to a attachable object" do
    note = Note.new
    animal = Animal.new

    photo1 = Photo.new :attachable => note
    photo2 = Photo.new :attachable => animal

    expect(photo1.attachable).to eq(note)
    expect(photo1.attachable).to be_instance_of(Note)

    expect(photo2.attachable).to eq(animal)
    expect(photo2.attachable).to be_instance_of(Animal)
  end
end

describe Photo, "#attachable?" do

  it "returns true if the photo has an attachable association" do
    animal = Animal.new
    photo1 = Photo.new :attachable => animal
    photo2 = Photo.new

    expect(photo1.attachable?).to eq(true)
    expect(photo2.attachable?).to eq(false)
  end
end

describe Photo, "#main_photo?" do

  it "returns true if the photo is a main photo or not" do
    photo1 = Photo.new :is_main_photo => true
    photo2 = Photo.new :is_main_photo => false

    expect(photo1.main_photo?).to eq(true)
    expect(photo2.main_photo?).to eq(false)
  end
end

