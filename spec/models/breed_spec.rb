require "spec_helper"

# Instance Methods
#----------------------------------------------------------------------------
describe Breed, "#animal_type" do

  it "should belong to an animal type" do
    animal_type = AnimalType.new :name => "Dog"
    breed       = Breed.new :animal_type => animal_type

    breed.animal_type.should == animal_type
  end

  it "should return a readonly animal_type" do
    breed = Breed.gen
    breed.reload.animal_type.should be_readonly
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Breed, ".valid_for_animal" do

  it "should validate the breed exists with the type" do
    Breed.gen :name => "Labrador Retriever"

    validation1 = Breed.valid_for_animal("Labrador Retriever", 1)
    validation2 = Breed.valid_for_animal("Labrador Retriever", 2)

    validation1.count.should == 1
    validation2.count.should == 0
  end
end

describe Breed, ".auto_complete" do

  it "should return the correct breeds per animal type" do
    animal_type = AnimalType.gen

    breed1 = Breed.gen :name => "Labrador Retriever", :animal_type => animal_type
    breed2 = Breed.gen :name => "Labrador Husky", :animal_type => animal_type

    breeds = Breed.auto_complete(animal_type.id, "Labrador").all

    breeds.count.should == 2
    breeds.should       =~ [breed1, breed2]
  end
end

describe "Typeable" do

  before do
    # Create 1 of each type and 1 breed for each type
    (1..AnimalType::TYPES.size).each {
      animal_type = AnimalType.gen
      Breed.gen :animal_type => animal_type
    }
  end

  describe Breed, ".dogs" do

    it "should return all of the dog breeds" do
      breeds = Breed.dogs
      breeds.count.should == 1
    end
  end

  describe Breed, ".cats" do

    it "should return all of the cat breeds" do
      breeds = Breed.cats
      breeds.count.should == 1
    end
  end

  describe Breed, ".horses" do

    it "should return all of the horse breeds" do
      breeds = Breed.horses
      breeds.count.should == 1
    end
  end

  describe Breed, ".rabbits" do

    it "should return all of the rabbit breeds" do
      breeds = Breed.rabbits
      breeds.count.should == 1
    end
  end

  describe Breed, ".birds" do

    it "should return all of the bird breeds" do
      breeds = Breed.birds
      breeds.count.should == 1
    end
  end

  describe Breed, ".reptiles" do

    it "should return all of the reptile breeds" do
      breeds = Breed.reptiles
      breeds.count.should == 1
    end
  end

  describe Breed, ".other" do

    it "should return all of the other breeds" do
      breeds = Breed.other
      breeds.count.should == 1
    end
  end

  describe Breed, "#dog?" do

    it "should validate if the breed is a dog" do
      breed1 = Breed.dogs.first
      breed2 = Breed.cats.first

      breed1.dog?.should == true
      breed2.dog?.should == false
    end
  end

  describe Breed, "#cat?" do

    it "should validate if the breed is a cat" do
      breed1 = Breed.cats.first
      breed2 = Breed.dogs.first

      breed1.cat?.should == true
      breed2.cat?.should == false
    end
  end

  describe Breed, "#horse?" do

    it "should validate if the breed is a horse" do
      breed1 = Breed.horses.first
      breed2 = Breed.dogs.first

      breed1.horse?.should == true
      breed2.horse?.should == false
    end
  end

  describe Breed, "#rabbit?" do

    it "should validate if the breed is a rabbit" do
      breed1 = Breed.rabbits.first
      breed2 = Breed.dogs.first

      breed1.rabbit?.should == true
      breed2.rabbit?.should == false
    end
  end

  describe Breed, "#bird?" do

    it "should validate if the breed is a bird" do
      breed1 = Breed.birds.first
      breed2 = Breed.dogs.first

      breed1.bird?.should == true
      breed2.bird?.should == false
    end
  end

  describe Breed, "#reptile?" do

    it "should validate if the breed is a reptile" do
      breed1 = Breed.reptiles.first
      breed2 = Breed.dogs.first

      breed1.reptile?.should == true
      breed2.reptile?.should == false
    end
  end

  describe Breed, "#other?" do

    it "should validate if the breed is an other" do
      breed1 = Breed.other.first
      breed2 = Breed.dogs.first

      breed1.other?.should == true
      breed2.other?.should == false
    end
  end
end

