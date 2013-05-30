FactoryGirl.define do

  factory :breed do
    sequence(:name) {|n| "Breed #{n}" }
    animal_type
  end
end


