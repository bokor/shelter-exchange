FactoryGirl.define do

  factory :location do
    sequence(:name) {|n| "location #{n}" }
    shelter
    created_at Time.now
    updated_at Time.now
  end
end

