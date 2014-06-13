FactoryGirl.define do

  factory :integration do
    sequence(:username) {|n| "username#{n}" }
    sequence(:password) {|n| "password#{n}" }
    shelter
  end

  factory :adopt_a_pet_integration, :parent => :integration, :class => "Integration::AdoptAPet" do
    type "Integration::AdoptAPet"
  end

  factory :petfinder_integration, :parent => :integration, :class => "Integration::Petfinder" do
    type "Integration::Petfinder"
  end
end

