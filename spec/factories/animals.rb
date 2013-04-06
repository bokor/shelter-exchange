FactoryGirl.define do

  factory :animal do
    sequence(:name) {|n| "animal name #{n}" }
    sequence(:microchip) {|n| "#1234-#{n}" }
    description      'Sweetest animal eva!'
    sex              'male'
    weight           '55 lbs'
    date_of_birth    2.years.ago
    is_sterilized    true
    color            'black'
    is_mix_breed     true
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
    size             'medium'
    age              'adult'
    shelter

    #after(:create) do |user, evaluator|
      #user.name.upcase! if evaluator.upcased
    #end
    # # status_change_date
    # # arrival_date
    # # hold_time
    # # euthanasia_date
    # # accommodation
    # # has_special_needs
    # # special_needs
    # # video_url
  end
end

