FactoryGirl.define do

  factory :transfer do
    animal
    requestor_shelter
    requestor
    sequence(:phone) {|n| "999999#{n+1000}" }
    sequence(:email) {|n| "shelter#{n}@example.com" }
    shelter
    status "Transfer status"
  end
end

