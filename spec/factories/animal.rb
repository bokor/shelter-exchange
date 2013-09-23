FactoryGirl.define do

  factory :animal do
    sequence(:name) {|n| "animal name #{n}" }
    sequence(:microchip) {|n| "#1234-#{n}" }
    description        "Sweetest animal eva!"
    sex                "male"
    weight             "55 lbs"
    date_of_birth      2.years.ago
    is_sterilized      true
    color              "black"
    is_mix_breed       true
    size               "M"
    age                "adult"
    status_change_date nil
    arrival_date       nil
    hold_time          nil
    euthanasia_date    nil
    has_special_needs  false
    special_needs      nil
    video_url          nil
    animal_type
    animal_status
    shelter
    accommodation
    primary_breed { Breed.gen(:animal_type => animal_type).name }
    secondary_breed { Breed.gen(:animal_type => animal_type).name }

    after(:build) do |animal|
      primary_breed = Breed.where(:name => animal.primary_breed).first
      secondary_breed = Breed.where(:name => animal.secondary_breed).first

      Breed.gen(:animal_type => animal.animal_type, :name => animal.primary_breed) unless primary_breed
      Breed.gen(:animal_type => animal.animal_type, :name => animal.secondary_breed) unless secondary_breed
    end
  end
end

