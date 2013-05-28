FactoryGirl.define do

  factory :animal_status do
    sequence(:name) {|n| "status #{n}" }
    sequence(:sort_order)
    created_at Time.now
    updated_at Time.now
  end
end

