FactoryGirl.define do

  factory :accommodation do
    shelter
    animal_type
    sequence(:name) {|n| "crate #{n}" }
    max_capacity 10
    location
  end
end

