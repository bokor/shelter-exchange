FactoryGirl.define do

  factory :contact do
    sequence(:first_name) {|n| "first_name_#{n}" }
    sequence(:last_name) {|n| "last_name_#{n}" }
    street          "123 Main Street"
    street_2        "n/a"
    city            "Redwood City"
    state           "CA"
    zip_code        "94063"
    sequence(:phone)    {|n| "999999#{n+1000}" }
    sequence(:mobile)   {|n| "999999#{n+1000}" }
    sequence(:email)    {|n| "email_#{n}@example.com" }
    shelter
  end
end

