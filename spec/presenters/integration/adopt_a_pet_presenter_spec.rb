require 'rails_helper'

describe Integration::AdoptAPetPresenter do

  before do
    @animal = Animal.gen
  end

  describe "#id" do
    it "returns the animal id" do
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.id).to eq(@animal.id)
    end
  end

  describe "#name" do
    it "returns the animal name" do
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.name).to eq(@animal.name)
    end
  end

  describe "#type" do

    it "returns the animal type name" do
      type = AnimalType.gen :name => "doggie"
      @animal.update_column(:animal_type_id, type.id)
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.type).to eq("doggie")
    end

    it "returns a mapped name for reptile" do
      @animal.update_column(:primary_breed, "Chameleon")
      @animal.update_column(:animal_type_id, AnimalType::TYPES[:reptile])
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.type).to eq("Reptile")
    end

    it "returns a mapped name for other" do
      @animal.update_column(:primary_breed, "Alpaca")
      @animal.update_column(:animal_type_id, AnimalType::TYPES[:other])
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.type).to eq("Farm Animal")
    end
  end

  describe "#breed" do

    it "returns the animals primary breed" do
      @animal.update_column(:primary_breed, "Lab")
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.breed).to eq("Lab")
    end
  end

  describe "#breed2" do

    it "returns nothing when not dog or horse and mix breed" do
      @animal.update_column(:animal_type_id, AnimalType::TYPES[:reptile])
      @animal.update_column(:secondary_breed, "Lab")
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.breed2).to be_nil
    end

    it "returns the animals primary breed when dog" do
      @animal.update_column(:animal_type_id, AnimalType::TYPES[:dog])
      @animal.update_column(:secondary_breed, "Lab")
      @animal.update_column(:is_mix_breed, false)
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.breed2).to eq("Lab")
    end

    it "returns the animals primary breed when horse and mix breed" do
      @animal.update_column(:animal_type_id, AnimalType::TYPES[:horse])
      @animal.update_column(:secondary_breed, "horse breed")
      @animal.update_column(:is_mix_breed, true)
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.breed2).to eq("horse breed")
    end
  end

  describe "#sex" do

    it "returns M for male" do
      @animal.update_column(:sex, "male")
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.sex).to eq("M")
    end

    it "returns F for female" do
      @animal.update_column(:sex, "female")
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.sex).to eq("F")
    end
  end

  describe "#description" do

    it "returns generic description when blank" do
      @animal.update_column(:description, nil)
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.description).to eq("<p>No description provided<br><a href=\"http://www.shelterexchange.org:9292/save_a_life/#{@animal.id}\">#{@animal.name}, #{@animal.full_breed}</a> has been shared from <a href=\"http://www.shelterexchange.org\">Shelter Exchange</a>.</p>")
    end

    it "returns formatted description" do
      @animal.update_column(:description, "this is cool.  www.example.org")
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.description).to eq("<p>this is cool.  <a href=\"http://www.example.org\" target=\"_blank\">www.example.org</a><br><a href=\"http://www.shelterexchange.org:9292/save_a_life/#{@animal.id}\">#{@animal.name}, #{@animal.full_breed}</a> has been shared from <a href=\"http://www.shelterexchange.org\">Shelter Exchange</a>.</p>")
    end

    it "returns formatted description with carriage returns" do
      @animal.update_column(:description, "hi\n bye\n\r")
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.description).to eq("<p>hi<br><br /> bye</p><br><br><p><br><a href=\"http://www.shelterexchange.org:9292/save_a_life/#{@animal.id}\">#{@animal.name}, #{@animal.full_breed}</a> has been shared from <a href=\"http://www.shelterexchange.org\">Shelter Exchange</a>.</p>")
    end
  end

  describe "#status" do

    it "returns status for animal" do
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.status).to eq("Available")
    end
  end

  describe "#purebred" do

    it "returns nil when not a dog, rabbit, or horse" do
      @animal.update_column(:animal_type_id, AnimalType::TYPES[:cat])
      @animal.update_column(:is_mix_breed, true)
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.purebred).to be_nil
    end

    context "when mixed breed" do

      it "returns N when dog" do
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:dog])
        @animal.update_column(:is_mix_breed, true)
        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.purebred).to eq("N")
      end

      it "returns N when rabbit" do
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:rabbit])
        @animal.update_column(:is_mix_breed, true)
        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.purebred).to eq("N")
      end

      it "returns N when horse" do
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:horse])
        @animal.update_column(:is_mix_breed, true)
        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.purebred).to eq("N")
      end
    end

    context "when not mixed breed" do

      it "returns Y when dog" do
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:dog])
        @animal.update_column(:is_mix_breed, false)
        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.purebred).to eq("Y")
      end

      it "returns Y when rabbit" do
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:rabbit])
        @animal.update_column(:is_mix_breed, false)
        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.purebred).to eq("Y")
      end

      it "returns Y when horse" do
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:horse])
        @animal.update_column(:is_mix_breed, false)
        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.purebred).to eq("Y")
      end
    end
  end

  describe "#special_needs" do

    it "returns N if animal mix" do
      @animal.update_column(:has_special_needs, false)
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.special_needs).to eq("N")
    end

    it "returns Y if animal mix" do
      @animal.update_column(:has_special_needs, true)
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.special_needs).to eq("Y")
    end
  end

  describe "#size" do

    it "returns size" do
      @animal.update_column(:size, "big")
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.size).to eq("big")
    end

    context "when size is not valid" do

      it "returns nil for blank size" do
        @animal.update_column(:size, nil)
        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.size).to be_nil
      end

      it "returns nil when cat" do
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:cat])
        @animal.update_column(:size, "XL")
        allow(@animal.animal_type).to receive(:name).and_return("Cat")

        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.size).to be_nil
      end

      it "returns nil when small animal" do
        @animal.update_column(:primary_breed, "Guinea Pig")
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:other])
        @animal.update_column(:size, "XL")
        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.size).to be_nil
      end
    end

    context "when XL should be L" do

      it "returns large for rabbit" do
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:rabbit])
        @animal.update_column(:size, "XL")
        allow(@animal.animal_type).to receive(:name).and_return("Rabbit")

        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.size).to eq("L")
      end

      it "returns large for farm animal" do
        @animal.update_column(:primary_breed, "Alpaca")
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:other])
        @animal.update_column(:size, "XL")
        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.size).to eq("L")
      end

      it "returns large for bird" do
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:bird])
        @animal.update_column(:size, "XL")
        allow(@animal.animal_type).to receive(:name).and_return("Bird")

        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.size).to eq("L")
      end

      it "returns large for horse" do
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:horse])
        @animal.update_column(:size, "XL")
        allow(@animal.animal_type).to receive(:name).and_return("Horse")

        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.size).to eq("L")
      end

      it "returns large for reptile" do
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:reptile])
        @animal.update_column(:primary_breed, "Chameleon")
        @animal.update_column(:size, "XL")
        allow(@animal.animal_type).to receive(:name).and_return("Reptile")

        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.size).to eq("L")
      end
    end
  end

  describe "#age" do

    it "returns nil when no age" do
      @animal.update_column(:age, nil)
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.age).to be_nil
    end

    it "returns humanized age" do
      @animal.update_column(:age, "old")
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.age).to eq("Old")
    end

    context "when age is baby" do

      it "returns puppy for dog" do
        @animal.update_column(:age, "baby")
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:dog])
        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.age).to eq("Puppy")
      end

      it "returns kitten for cat" do
        @animal.update_column(:age, "baby")
        @animal.update_column(:animal_type_id, AnimalType::TYPES[:cat])
        presenter = Integration::AdoptAPetPresenter.new(@animal)
        expect(presenter.age).to eq("Kitten")
      end
    end
  end

  describe "#photos" do

    it "returns an array of nil photos" do
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.photos).to match_array([nil, nil, nil, nil])
    end

    it "returns an max array of 4 photos" do
      photo1 = Photo.gen :attachable => @animal
      photo2 = Photo.gen :attachable => @animal
      photo3 = Photo.gen :attachable => @animal
      photo4 = Photo.gen :attachable => @animal

      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.photos).to match_array([
        "http://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{photo1.image.filename}",
        "http://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{photo2.image.filename}",
        "http://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{photo3.image.filename}",
        "http://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{photo4.image.filename}"
      ])
    end

    it "returns an array of 2 images and 2 nil" do
      photo1 = Photo.gen :attachable => @animal
      photo2 = Photo.gen :attachable => @animal

      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.photos).to match_array([
        "http://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{photo1.image.filename}",
        "http://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal.id}/original/#{photo2.image.filename}",
        nil,
        nil
      ])
    end
  end

  describe "#you_tube_url" do

    it "returns nil when no video_url" do
      @animal.update_column(:video_url, "")
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.you_tube_url).to be_nil
    end

    it "returns nil when url is not youtube url" do
      @animal.update_column(:video_url, "http://vimeo.com/98306475")
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.you_tube_url).to be_nil
    end

    it "returns playable youtube video url" do
      @animal.update_column(:video_url, "https://www.youtube.com/watch?v=Kc6By-4NvZA")
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.you_tube_url).to eq("http://www.youtube.com/watch?v=Kc6By-4NvZA")
    end
  end

  describe "#to_csv" do

    it "returns the animal in a csv row format" do
      presenter = Integration::AdoptAPetPresenter.new(@animal)
      expect(presenter.to_csv).to eq([
        presenter.id,
        presenter.type,
        presenter.breed,
        presenter.breed2,
        presenter.name,
        presenter.sex,
        presenter.description,
        presenter.status,
        presenter.purebred,
        presenter.special_needs,
        presenter.size,
        presenter.age,
        presenter.you_tube_url
      ].concat(presenter.photos))
    end
  end

  describe ".csv_header" do
    it "returns the csv header" do
      expect(
        Integration::AdoptAPetPresenter.csv_header
      ).to eq([
        "Id",
        "Animal",
        "Breed",
        "Breed2",
        "Name",
        "Sex",
        "Description",
        "Status",
        "Purebred",
        "SpecialNeeds",
        "Size",
        "Age",
        "YouTubeVideoURL",
        "PhotoURL",
        "PhotoURL2",
        "PhotoURL3",
        "PhotoURL4"
      ])
    end
  end

  describe ".as_csv" do
    it "returns a collection in csv format" do
      animal1 = Animal.gen
      animal2 = Animal.gen
      csv = []

      Integration::AdoptAPetPresenter.as_csv([animal1,animal2], csv)

      expect(csv).to match_array([
        Integration::AdoptAPetPresenter.csv_header,
        Integration::AdoptAPetPresenter.new(animal1).to_csv,
        Integration::AdoptAPetPresenter.new(animal2).to_csv
      ])
    end
  end
end

