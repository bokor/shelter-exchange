require "spec_helper"

describe Breed, "#animal_type" do

  it "should belong to an animal type" do
    breed = Breed.first

    breed.should respond_to(:animal_type)
    animal_type = breed.animal_type

    animal_type.id.should   == 1
    animal_type.name.should == "Dog"
  end

  it "should return a readonly animal_type" do
    breed = Breed.first
    breed.animal_type.should be_readonly
  end
end

describe Breed, ".valid_for_animal" do

  it "should validate the breed exists with the type" do
    breed1 = Breed.valid_for_animal("Labrador Retriever", AnimalType::TYPES[:dog])
    breed2 = Breed.valid_for_animal("Labrador Retriever", AnimalType::TYPES[:cat])

    breed1.count.should == 1
    breed2.count.should == 0
  end
end

describe Breed, ".auto_complete" do

  it "should return the correct breeds per animal type" do
    breeds = Breed.auto_complete(AnimalType::TYPES[:dog], "Labrador").all

    breeds.count.should == 2
    breeds.map(&:name).should == ["Labrador Husky", "Labrador Retriever"]
  end
end

describe Breed, ".dogs" do

  it "should return all of the dog breeds" do
    breeds = Breed.dogs
    breeds.count.should == 263
  end
end

describe Breed, ".cats" do

  it "should return all of the cat breeds" do
    breeds = Breed.cats
    breeds.count.should == 66
  end
end

describe Breed, ".horses" do

  it "should return all of the horse breeds" do
    breeds = Breed.horses
    breeds.count.should == 52
  end
end

describe Breed, ".rabbits" do

  it "should return all of the rabbit breeds" do
    breeds = Breed.rabbits
    breeds.count.should == 49
  end
end

describe Breed, ".birds" do

  it "should return all of the bird breeds" do
    breeds = Breed.birds
    breeds.count.should == 42
  end
end

describe Breed, ".reptiles" do

  it "should return all of the reptile breeds" do
    breeds = Breed.reptiles
    breeds.count.should == 7
  end
end

describe Breed, ".other" do

  it "should return all of the other breeds" do
    breeds = Breed.other
    breeds.count.should == 16
  end
end

describe Breed, "#dog?" do

  it "should validate if the breed is a dog" do
    breed1 = Breed.find(1)   # Dog
    breed2 = Breed.find(300) # Cat

    breed1.dog?.should == true
    breed2.dog?.should == false
  end
end

describe Breed, "#cat?" do

  it "should validate if the breed is a cat" do
    breed1 = Breed.find(300) # Cat
    breed2 = Breed.find(1)   # Dog

    breed1.cat?.should == true
    breed2.cat?.should == false
  end
end

describe Breed, "#horse?" do

  it "should validate if the breed is a horse" do
    breed1 = Breed.find(350) # Horse
    breed2 = Breed.find(1)   # Dog

    breed1.horse?.should == true
    breed2.horse?.should == false
  end
end

describe Breed, "#rabbit?" do

  it "should validate if the breed is a rabbit" do
    breed1 = Breed.find(400) # Rabbit
    breed2 = Breed.find(1)   # Dog

    breed1.rabbit?.should == true
    breed2.rabbit?.should == false
  end
end

describe Breed, "#bird?" do

  it "should validate if the breed is a bird" do
    breed1 = Breed.find(450) # Bird
    breed2 = Breed.find(1)   # Dog

    breed1.bird?.should == true
    breed2.bird?.should == false
  end
end

describe Breed, "#reptile?" do

  it "should validate if the breed is a reptile" do
    breed1 = Breed.find(475) # Reptile
    breed2 = Breed.find(1)   # Dog

    breed1.reptile?.should == true
    breed2.reptile?.should == false
  end
end

describe Breed, "#other?" do

  it "should validate if the breed is an other" do
    breed1 = Breed.find(490) # Other
    breed2 = Breed.find(1)   # Dog

    breed1.other?.should == true
    breed2.other?.should == false
  end
end

