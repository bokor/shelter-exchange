FactoryGirl.define do

  factory :location do
    sequence(:name) {|n| "location #{n}" }
    shelter
  end
end

