FactoryGirl.define do

  factory :animal_status do
    sequence(:name) {|n| "status #{n}" }
    sequence(:sort_order)
  end
end

