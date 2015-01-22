FactoryGirl.define do

  factory :integration do
    sequence(:username) {|n| "username#{n}" }
    sequence(:password) {|n| "password#{n}" }
    shelter
  end

  factory :adopt_a_pet_integration, :parent => :integration, :class => "Integration::AdoptAPet" do
    type "Integration::AdoptAPet"
    after(:build) { |adopt_a_pet|
      adopt_a_pet.class.skip_callback(:save, :after, :update_remote_animals)
    }
  end

  factory :adopt_a_pet_with_after_save_callback_integration, :parent => :integration, :class => "Integration::AdoptAPet" do
    type "Integration::AdoptAPet"
    after(:build) { |adopt_a_pet|
      adopt_a_pet.class.set_callback(:save, :after, :update_remote_animals)
    }
  end

  factory :petfinder_integration, :parent => :integration, :class => "Integration::Petfinder" do
    type "Integration::Petfinder"
    after(:build) { |petfinder|
      petfinder.class.skip_callback(:save, :after, :update_remote_animals)
    }
  end

  factory :petfinder_with_after_save_callback_integration, :parent => :integration, :class => "Integration::Petfinder" do
    type "Integration::Petfinder"
    after(:build) { |petfinder|
      petfinder.class.set_callback(:save, :after, :update_remote_animals)
    }
  end
end

