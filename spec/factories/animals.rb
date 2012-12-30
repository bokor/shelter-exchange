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
    primary_breed    'Labrador Retriever'
    secondary_breed  'Border Collie'
    animal_type_id   1
    animal_status_id 1
    size             'medium'
    age              'adult'
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