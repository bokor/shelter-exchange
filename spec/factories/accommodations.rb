FactoryGirl.define do

  factory :accommodation do
    shelter
    animal_type
    sequence(:name) {|n| "crate #{n}" }
    max_capacity 10
    location
    created_at Time.now
    updated_at Time.now
  end
end

