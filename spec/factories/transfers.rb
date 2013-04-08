FactoryGirl.define do

  factory :transfer do
    animal
    requestor_shelter
    requestor
    phone     "999-999-9999"
    sequence(:email) {|n| "shelter#{n}@example.com" }
    shelter
    status "Transfer status"
  end
end

