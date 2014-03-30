FactoryGirl.define do

  factory :transfer do
    sequence(:requestor) {|n| "Requestor #{n}" }
    sequence(:phone) {|n| "999999#{n+1000}" }
    sequence(:email) {|n| "shelter#{n}@example.com" }
    status nil
    shelter
    animal
    requestor_shelter
  end
end

