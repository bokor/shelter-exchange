FactoryGirl.define do

  factory :integration do
    username "username"
    password "password"
    shelter
  end

  # factory :adopt_a_pet_integration, :class => :integration do
  #   type "Integration::AdoptAPet"
  # end
end

