FactoryGirl.define do

  factory :breed do
    sequence(:name) {|n| "Breed #{n}" }
    animal_type
    created_at Time.now
    updated_at Time.now
  end
end


