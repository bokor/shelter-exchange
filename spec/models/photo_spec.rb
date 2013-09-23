require 'spec_helper'

describe Photo do

  it_should_behave_like Uploadable

  it "has a default scope" do
    Photo.scoped.to_sql.should == Photo.order('photos.is_main_photo DESC, photos.created_at DESC').to_sql
  end

  it "sets the original name" do
    file = File.open("#{Rails.root}/spec/data/images/photo.jpg")
    photo = Photo.gen(:image => file)
    photo.original_name.should == "photo.jpg"
  end

  it "validates the max number of additional photos for an attachable" do
    note = Note.new
    Photo.gen(:attachable => note, :is_main_photo => false)
    Photo.gen(:attachable => note, :is_main_photo => false)
    Photo.gen(:attachable => note, :is_main_photo => false)
    Photo.gen(:attachable => note, :is_main_photo => false)

    photo = Photo.gen(:attachable => note)
    photo.should have(1).error
    photo.errors[:base].should == ["Max number of files exceeded"]
  end
end

# Constants
#----------------------------------------------------------------------------
describe Photo, "::TOTAL_MAIN" do

  it "returns the total number of main photos" do
    Photo::TOTAL_MAIN.should == 1
  end
end

describe Photo, "::TOTAL_ADDITIONAL" do

  it "returns the total number of additional photos" do
    Photo::TOTAL_ADDITIONAL.should == 3
  end
end

describe Photo, "::MAX_TOTAL" do

  it "returns the total max total of photos" do
    Photo::MAX_TOTAL.should == 4
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Photo, ".main_photo" do

  it "returns only the main photos" do
    photo1 = Photo.gen(:is_main_photo => true)
    photo2 = Photo.gen(:is_main_photo => true)
    photo3 = Photo.gen(:is_main_photo => false)
    photo4 = Photo.gen(:is_main_photo => false)

    photos = Photo.main_photo
    photos.should =~ [photo1, photo2]
  end
end

describe Photo, ".not_main_photo" do

  it "returns only the main photos" do
    photo1 = Photo.gen(:is_main_photo => false)
    photo2 = Photo.gen(:is_main_photo => false)
    photo3 = Photo.gen(:is_main_photo => true)
    photo4 = Photo.gen(:is_main_photo => true)

    photos = Photo.not_main_photo
    photos.should =~ [photo1, photo2]
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

    photo1.attachable.should == note
    photo1.attachable.should be_instance_of(Note)

    photo2.attachable.should == animal
    photo2.attachable.should be_instance_of(Animal)
  end
end

describe Photo, "#attachable?" do

  it "returns true if the photo has an attachable association" do
    animal  = Animal.new
    photo1 = Photo.new :attachable => animal
    photo2 = Photo.new

    photo1.attachable?.should == true
    photo2.attachable?.should == false
  end
end

describe Photo, "#main_photo?" do

  it "returns true if the photo is a main photo or not" do
    photo1 = Photo.new :is_main_photo => true
    photo2 = Photo.new :is_main_photo => false

    photo1.main_photo?.should == true
    photo2.main_photo?.should == false
  end
end

