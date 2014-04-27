require "spec_helper"

describe Public::ApplicationHelper, "#description" do

  it "returns content_for description" do
    helper.description("Sample Description")
    expect(
      helper.content_for(:description)
    ).to eq("Sample Description")
  end
end

describe Public::ApplicationHelper, "#keywords" do

  it "returns content_for keywords" do
    helper.keywords("animals, pets")
    expect(
      helper.content_for(:keywords)
    ).to eq("animals, pets")
  end
end

describe Public::ApplicationHelper, "#robots" do

  it "returns content_for robots" do
    helper.robots("index, nofollow")
    expect(
      helper.content_for(:robots)
    ).to eq("index, nofollow")
  end
end

describe Public::ApplicationHelper, "#open_graph_image" do

  it "returns content_for open_graph_image" do
    helper.open_graph_image("http://open.graph/image.jpg")
    expect(
      helper.content_for(:open_graph_image)
    ).to eq("http://open.graph/image.jpg")
  end
end

describe Public::ApplicationHelper, "#open_graph_title" do

  it "returns content_for open_graph_title" do
    helper.open_graph_title("open_graph title")
    expect(
      helper.content_for(:open_graph_title)
    ).to eq("open_graph title")
  end
end

describe Public::ApplicationHelper, "#open_graph_title_status" do

  it "returns status text for an animal in foster care" do
    status = AnimalStatus.gen :id => 3, :name => "Foster care"
    animal = Animal.gen :animal_status => status

    expect(
      helper.open_graph_title_status(animal)
    ).to eq("IN FOSTER CARE!")
  end

  it "returns status text for a deceased animal" do
    status = AnimalStatus.gen :id => 13, :name => "Deceased"
    animal = Animal.gen :animal_status => status

    expect(
      helper.open_graph_title_status(animal)
    ).to eq("NOT AVAILABLE!")
  end

  it "returns status text for an euthanized animal" do
    status = AnimalStatus.gen :id => 14, :name => "Euthanized"
    animal = Animal.gen :animal_status => status

    expect(
      helper.open_graph_title_status(animal)
    ).to eq("NOT AVAILABLE!")
  end

  it "returns status text for an adopted animal" do
    status = AnimalStatus.gen :id => 2, :name => "Adopted"
    animal = Animal.gen :animal_status => status

    expect(
      helper.open_graph_title_status(animal)
    ).to eq("ADOPTED!")
  end

  it "returns status text for a reclaimed animal" do
    status = AnimalStatus.gen :id => 12, :name => "Reclaimed"
    animal = Animal.gen :animal_status => status

    expect(
      helper.open_graph_title_status(animal)
    ).to eq("RECLAIMED!")
  end

  it "returns status text for an adoption pending animal" do
    status = AnimalStatus.gen :id => 16, :name => "Adoption Pending"
    animal = Animal.gen :animal_status => status

    expect(
      helper.open_graph_title_status(animal)
    ).to eq("ADOPTION PENDING!")
  end
end

describe Public::ApplicationHelper, "#pinterest_animal_description" do

  it "returns animal description for available for adoption" do
    type = AnimalType.gen :name => "dog"
    shelter = Shelter.gen :name => "Cute Doggies", :city => "Redwood city", :state => "CA"
    animal = Animal.gen \
      :shelter => shelter,
      :animal_type => type,
      :name => "Billy",
      :sex => "male",
      :primary_breed => "Labrador Retriever",
      :is_mix_breed => true,
      :animal_status_id => AnimalStatus::STATUSES[:available_for_adoption]

    expect(
      helper.pinterest_animal_description(animal, shelter)
    ).to eq("Available for adoption - Billy is a male dog, Labrador Retriever Mix, located at Cute Doggies in Redwood city, CA.")
  end

  it "returns animal description for adoption pending" do
    type = AnimalType.gen :name => "dog"
    shelter = Shelter.gen :name => "Cute Doggies", :city => "Redwood city", :state => "CA"
    animal = Animal.gen \
      :shelter => shelter,
      :animal_type => type,
      :name => "Billy",
      :sex => "male",
      :primary_breed => "Labrador Retriever",
      :is_mix_breed => true,
      :animal_status_id => AnimalStatus::STATUSES[:adoption_pending]

    expect(
      helper.pinterest_animal_description(animal, shelter)
    ).to eq("Adoption pending - Billy is a male dog, Labrador Retriever Mix, located at Cute Doggies in Redwood city, CA.")
  end

  context "any status other than available_for_adoption or adoption_pending" do
    it "returns animal description" do
      type = AnimalType.gen :name => "dog"
      shelter = Shelter.gen :name => "Cute Doggies", :city => "Redwood city", :state => "CA"
      animal = Animal.gen \
        :shelter => shelter,
        :animal_type => type,
        :name => "Billy",
        :sex => "male",
        :primary_breed => "Labrador Retriever",
        :is_mix_breed => true,
        :animal_status_id => AnimalStatus::STATUSES[:reclaimed]

      expect(
        helper.pinterest_animal_description(animal, shelter)
      ).to eq("Billy is a male dog, Labrador Retriever Mix, located at Cute Doggies in Redwood city, CA.")
    end
  end
end

describe Public::ApplicationHelper, "#pinterest_shelter_description" do

  it "returns the shelter description" do
    shelter = Shelter.gen :name => "Cute Doggies", :city => "Redwood city", :state => "CA"
    expect(
      helper.pinterest_shelter_description(shelter)
    ).to eq("Help the Cute Doggies, located in Redwood city, CA, by adopting an animal or donating items most needed at this shelter or rescue group.")
  end
end

