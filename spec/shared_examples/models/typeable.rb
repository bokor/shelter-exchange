shared_examples_for Typeable do

  before :all do
    @dog = AnimalType.where(:id => AnimalType::TYPES[:dog]).first || AnimalType.gen(:id => AnimalType::TYPES[:dog])
    @cat = AnimalType.where(:id => AnimalType::TYPES[:cat]).first || AnimalType.gen(:id => AnimalType::TYPES[:cat])
    @horse = AnimalType.where(:id => AnimalType::TYPES[:horse]).first || AnimalType.gen(:id => AnimalType::TYPES[:horse])
    @rabbit = AnimalType.where(:id => AnimalType::TYPES[:rabbit]).first || AnimalType.gen(:id => AnimalType::TYPES[:rabbit])
    @bird = AnimalType.where(:id => AnimalType::TYPES[:bird]).first || AnimalType.gen(:id => AnimalType::TYPES[:bird])
    @reptile = AnimalType.where(:id => AnimalType::TYPES[:reptile]).first || AnimalType.gen(:id => AnimalType::TYPES[:reptile])
    @other = AnimalType.where(:id => AnimalType::TYPES[:other]).first || AnimalType.gen(:id => AnimalType::TYPES[:other])
  end

  describe described_class, ".dogs" do

    it "returns all of the dog records" do
      described_class.gen(:animal_type => @dog)
      described_class.gen(:animal_type => @cat)

      described_class.dogs.count.should == 1
    end
  end

  describe described_class, ".cats" do

    it "returns all of the cat records" do
      described_class.gen(:animal_type => @cat)
      described_class.gen(:animal_type => @dog)

      described_class.cats.count.should == 1
    end
  end

  describe described_class, ".horses" do

    it "returns all of the horse records" do
      described_class.gen(:animal_type => @horse)
      described_class.gen(:animal_type => @dog)

      described_class.horses.count.should == 1
    end
  end

  describe described_class, ".rabbits" do

    it "returns all of the rabbit records" do
      described_class.gen(:animal_type => @rabbit)
      described_class.gen(:animal_type => @dog)

      described_class.rabbits.count.should == 1
    end
  end

  describe described_class, ".birds" do

    it "returns all of the bird records" do
      described_class.gen(:animal_type => @bird)
      described_class.gen(:animal_type => @dog)

      described_class.birds.count.should == 1
    end
  end

  describe described_class, ".reptiles" do

    it "returns all of the reptile records" do
      described_class.gen(:animal_type => @reptile)
      described_class.gen(:animal_type => @dog)

      described_class.reptiles.count.should == 1
    end
  end

  describe described_class, ".other" do

    it "returns all of the other records" do
      described_class.gen(:animal_type => @other)
      described_class.gen(:animal_type => @dog)

      described_class.other.count.should == 1
    end
  end

  describe described_class, "#dog?" do

    it "returns true if the #{described_class} is a dog" do
      typeable1 = described_class.gen(:animal_type => @dog)
      typeable2 = described_class.gen(:animal_type => @cat)

      typeable1.dog?.should == true
      typeable2.dog?.should == false
    end
  end

  describe described_class, "#cat?" do

    it "returns true if the #{described_class} is a cat" do
      typeable1 = described_class.gen(:animal_type => @cat)
      typeable2 = described_class.gen(:animal_type => @dog)

      typeable1.cat?.should == true
      typeable2.cat?.should == false
    end
  end

  describe described_class, "#horse?" do

    it "returns true if the #{described_class} is a horse" do
      typeable1 = described_class.gen(:animal_type => @horse)
      typeable2 = described_class.gen(:animal_type => @dog)

      typeable1.horse?.should == true
      typeable2.horse?.should == false
    end
  end

  describe described_class, "#rabbit?" do

    it "returns true if the #{described_class} is a rabbit" do
      typeable1 = described_class.gen(:animal_type => @rabbit)
      typeable2 = described_class.gen(:animal_type => @dog)

      typeable1.rabbit?.should == true
      typeable2.rabbit?.should == false
    end
  end

  describe described_class, "#bird?" do

    it "returns true if the #{described_class} is a bird" do
      typeable1 = described_class.gen(:animal_type => @bird)
      typeable2 = described_class.gen(:animal_type => @dog)

      typeable1.bird?.should == true
      typeable2.bird?.should == false
    end
  end

  describe described_class, "#reptile?" do

    it "returns true if the #{described_class} is a reptile" do
      typeable1 = described_class.gen(:animal_type => @reptile)
      typeable2 = described_class.gen(:animal_type => @dog)

      typeable1.reptile?.should == true
      typeable2.reptile?.should == false
    end
  end

  describe described_class, "#other?" do

    it "returns true if the #{described_class} is an other" do
      typeable1 = described_class.gen(:animal_type => @other)
      typeable2 = described_class.gen(:animal_type => @dog)

      typeable1.other?.should == true
      typeable2.other?.should == false
    end
  end
end

