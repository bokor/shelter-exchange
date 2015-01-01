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

      typeables = described_class.dogs
      expect(typeables.count).to eq(1)
    end
  end

  describe described_class, ".cats" do

    it "returns all of the cat records" do
      described_class.gen(:animal_type => @cat)
      described_class.gen(:animal_type => @dog)

      typeables = described_class.cats
      expect(typeables.count).to eq(1)
    end
  end

  describe described_class, ".horses" do

    it "returns all of the horse records" do
      described_class.gen(:animal_type => @horse)
      described_class.gen(:animal_type => @dog)

      typeables = described_class.horses
      expect(typeables.count).to eq(1)
    end
  end

  describe described_class, ".rabbits" do

    it "returns all of the rabbit records" do
      described_class.gen(:animal_type => @rabbit)
      described_class.gen(:animal_type => @dog)

      typeables = described_class.rabbits
      expect(typeables.count).to eq(1)
    end
  end

  describe described_class, ".birds" do

    it "returns all of the bird records" do
      described_class.gen(:animal_type => @bird)
      described_class.gen(:animal_type => @dog)

      typeables = described_class.birds
      expect(typeables.count).to eq(1)
    end
  end

  describe described_class, ".reptiles" do

    it "returns all of the reptile records" do
      described_class.gen(:animal_type => @reptile)
      described_class.gen(:animal_type => @dog)

      typeables = described_class.reptiles
      expect(typeables.count).to eq(1)
    end
  end

  describe described_class, ".other" do

    it "returns all of the other records" do
      described_class.gen(:animal_type => @other)
      described_class.gen(:animal_type => @dog)

      typeables = described_class.other
      expect(typeables.count).to eq(1)
    end
  end

  describe described_class, "#dog?" do

    it "returns true if the #{described_class} is a dog" do
      typeable1 = described_class.gen(:animal_type => @dog)
      typeable2 = described_class.gen(:animal_type => @cat)

      expect(typeable1.dog?).to be_truthy
      expect(typeable2.dog?).to be_falsey
    end
  end

  describe described_class, "#cat?" do

    it "returns true if the #{described_class} is a cat" do
      typeable1 = described_class.gen(:animal_type => @cat)
      typeable2 = described_class.gen(:animal_type => @dog)

      expect(typeable1.cat?).to be_truthy
      expect(typeable2.cat?).to be_falsey
    end
  end

  describe described_class, "#horse?" do

    it "returns true if the #{described_class} is a horse" do
      typeable1 = described_class.gen(:animal_type => @horse)
      typeable2 = described_class.gen(:animal_type => @dog)

      expect(typeable1.horse?).to be_truthy
      expect(typeable2.horse?).to be_falsey
    end
  end

  describe described_class, "#rabbit?" do

    it "returns true if the #{described_class} is a rabbit" do
      typeable1 = described_class.gen(:animal_type => @rabbit)
      typeable2 = described_class.gen(:animal_type => @dog)

      expect(typeable1.rabbit?).to be_truthy
      expect(typeable2.rabbit?).to be_falsey
    end
  end

  describe described_class, "#bird?" do

    it "returns true if the #{described_class} is a bird" do
      typeable1 = described_class.gen(:animal_type => @bird)
      typeable2 = described_class.gen(:animal_type => @dog)

      expect(typeable1.bird?).to be_truthy
      expect(typeable2.bird?).to be_falsey
    end
  end

  describe described_class, "#reptile?" do

    it "returns true if the #{described_class} is a reptile" do
      typeable1 = described_class.gen(:animal_type => @reptile)
      typeable2 = described_class.gen(:animal_type => @dog)

      expect(typeable1.reptile?).to be_truthy
      expect(typeable2.reptile?).to be_falsey
    end
  end

  describe described_class, "#other?" do

    it "returns true if the #{described_class} is an other" do
      typeable1 = described_class.gen(:animal_type => @other)
      typeable2 = described_class.gen(:animal_type => @dog)

      expect(typeable1.other?).to be_truthy
      expect(typeable2.other?).to be_falsey
    end
  end
end

