FactoryGirl.define do

  factory :integration do
    username "username"
    password "password"
    shelter
  end

  factory :adopt_a_pet_integration, :parent => :integration do
    type "Integration::AdoptAPet"
  end

  factory :petfinder_integration, :parent => :integration do
    type "Integration::Petfinder"
  end
end

