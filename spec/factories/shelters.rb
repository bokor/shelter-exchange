FactoryGirl.define do
  sequence(:name) {|n| "Shelter #{n}" }
  sequence(:phone) {|n| "999999#{n+1000}" }
  sequence(:email) {|n| "shelter#{n}@example.com" }

  factory :shelter, :aliases => [:requestor_shelter] do
    name
    phone
    email
    website "http://www.shelterexchange.org"
    twitter "@shelterexchange"
    facebook "http://www.facebook.com/shelterexchange"
    street "123 Main St."
    street_2 "Apt 101"
    city "Redwood City"
    state "CA"
    zip_code "94063"
    time_zone "Pacific Time (US & Canada)"
    status "active"
    is_kill_shelter false

    after(:build) {|shelter|
      shelter.class.skip_callback(:save, :after, :update_map_details)
    }
  end

  factory :with_after_save_callback_shelter, :class => "Shelter" do
    name
    phone
    email
    website "http://www.shelterexchange.org"
    twitter "@shelterexchange"
    facebook "http://www.facebook.com/shelterexchange"
    street "123 Main St."
    street_2 "Apt 101"
    city "Redwood City"
    state "CA"
    zip_code "94063"
    time_zone "Pacific Time (US & Canada)"
    status "active"
    is_kill_shelter false
    after(:build) { |shelter|
      shelter.class.set_callback(:save, :after, :update_map_details)
    }
  end
end

