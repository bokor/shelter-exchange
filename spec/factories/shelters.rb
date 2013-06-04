FactoryGirl.define do

  factory :shelter, :aliases => [:requestor_shelter] do
    sequence(:name) {|n| "Shelter #{n}" }
    sequence(:phone) {|n| "999999#{n+1000}" }
    sequence(:email) {|n| "shelter#{n}@example.com" }
    website         "http://www.shelterexchange.org"
    twitter         "@shelterexchange"
    facebook        "http://www.facebook.com/shelterexchange"
    street          "123 Main St."
    street_2        "Apt 101"
    city            "Redwood City"
    state           "CA"
    zip_code        "94063"
    time_zone       "Pacific Time (US & Canada)"
    status          "active"
    is_kill_shelter false
  end
end
