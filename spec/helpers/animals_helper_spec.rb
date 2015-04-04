require "rails_helper"

describe AnimalsHelper, "#filter_by_animal_statuses" do

  it "returns an array of filter options" do
    status = AnimalStatus.gen :name => "Testing status"
    expect(
      helper.filter_by_animal_statuses
    ).to match_array([
      ["All Active", :active],
      ["All Non-Active", :non_active],
      ["All Active and Non-Active", :active_and_non_active],
      ["Testing status", status.id]
    ])
  end
end

describe AnimalsHelper, "#public_animal_status" do

  it "returns text when animal is deceased" do
    animal = Animal.gen :animal_status_id => 13

    expect(
      helper.public_animal_status(animal)
    ).to eq("No longer available for adoption")
  end

  it "returns text when animal is euthanized" do
    animal = Animal.gen :animal_status_id => 14

    expect(
      helper.public_animal_status(animal)
    ).to eq("No longer available for adoption")
  end

  it "returns animal status name" do
    status = AnimalStatus.gen :id => 1, :name => "status_name"
    animal = Animal.gen :animal_status => status

    expect(
      helper.public_animal_status(animal)
    ).to eq(status.name)
  end
end

describe AnimalsHelper, "#fancybox_video_url" do

  it "returns animal video url" do
    animal = Animal.gen :video_url => "http://video.host/?id=123"

    expect(
      helper.fancybox_video_url(animal)
    ).to eq("http://video.host/?id=123")
  end

  it "returns correct youtube url for the video player" do
    animal = Animal.gen :video_url => "https://www.youtube.com/watch?v=YlmidIPuZ58"

    expect(
      helper.fancybox_video_url(animal)
    ).to eq("//www.youtube.com/v/YlmidIPuZ58")
  end
end

describe AnimalsHelper, "#find_you_tube_id" do

  it "returns nil and does not match the youtube id" do
    url = "http://video.host/?id=123"

    expect(
      helper.find_you_tube_id(url)
    ).to be_nil
  end

  it "returns the matched youtube id" do
    url = "https://www.youtube.com/watch?v=YlmidIPuZ58"

    expect(
      helper.find_you_tube_id(url)
    ).to eq("YlmidIPuZ58")
  end
end

