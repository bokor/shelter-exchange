FactoryGirl.define do

  factory :animal do
    sequence(:name) {|n| "animal name #{n}" }
    sequence(:microchip) {|n| "#1234-#{n}" }
    description        "Sweetest animal eva!"
    sex                "male"
    weight             "55 lbs"
    is_sterilized      true
    color              "black"
    is_mix_breed       true
    size               "M"
    age                "adult"
    status_change_date nil
    date_of_birth      nil
    arrival_date       nil
    hold_time          nil
    euthanasia_date    nil
    has_special_needs  false
    special_needs      nil
    video_url          nil
    animal_type
    animal_status
    shelter
    primary_breed { Breed.gen(:animal_type_id => animal_type_id).name }
    secondary_breed  nil

    after(:build) do |animal|
      primary_breed = animal.primary_breed.strip unless animal.primary_breed.nil?
      primary_breed = Breed.where(:animal_type_id => animal.animal_type_id, :name => primary_breed).first
      Breed.gen(:animal_type_id => animal.animal_type_id, :name => animal.primary_breed) unless primary_breed

      unless animal.secondary_breed.blank?
        secondary_breed = animal.secondary_breed.strip
        secondary_breed = Breed.where(:animal_type_id => animal.animal_type_id, :name => secondary_breed).first
        Breed.gen(:animal_type_id => animal.animal_type_id, :name => animal.secondary_breed) unless secondary_breed
      end
    end

  end
end

