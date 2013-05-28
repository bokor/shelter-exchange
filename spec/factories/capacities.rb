FactoryGirl.define do

  factory :capacity do
    shelter
    animal_type
    max_capacity 10
    created_at Time.now
    updated_at Time.now
  end
end

