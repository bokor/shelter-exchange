FactoryGirl.define do

  factory :transfer do
    sequence(:requestor) {|n| "Requestor #{n}" }
    sequence(:phone) {|n| "999999#{n+1000}" }
    sequence(:email) {|n| "shelter#{n}@example.com" }
    status "" #Blank is the default
    shelter
    animal
    requestor_shelter
    created_at Time.now
    updated_at Time.now
  end
end

