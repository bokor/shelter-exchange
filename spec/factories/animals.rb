FactoryGirl.define do

  factory :animal do
    sequence(:name) {|n| "animal name #{n}" }
    sequence(:microchip) {|n| "#1234-#{n}" }
    description        'Sweetest animal eva!'
    sex                'male'
    weight             '55 lbs'
    date_of_birth      2.years.ago
    is_sterilized      true
    color              'black'
    is_mix_breed       true
    size               'medium'
    age                'adult'
    status_change_date nil
    arrival_date       nil
    hold_time          nil
    euthanasia_date    nil
    has_special_needs  false
    special_needs      ""
    video_url          ""
    primary_breed    {
      (Breed.where(:animal_type_id => animal_type, :name => 'Labrador Retriever').first ||
      Breed.gen(:animal_type => animal_type, :name => 'Labrador Retriever')).name
    }
    secondary_breed  {
      (Breed.where(:animal_type_id => animal_type, :name => 'Border Collie').first ||
      Breed.gen(:animal_type => animal_type, :name => 'Border Collie')).name
    }
    animal_type
    animal_status
    shelter
    accommodation
  end
end

