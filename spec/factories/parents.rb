FactoryGirl.define do

  factory :parent do
    sequence(:name) {|n| "parent name #{n}" }
    street          "123 Main Street"
    street_2        "n/a"
    city            "Redwood City"
    state           "CA"
    zip_code        "94063"
    sequence(:phone)    {|n| "999999#{n+1000}" }
    sequence(:mobile)   {|n| "999999#{n+1000}" }
    sequence(:email)    {|n| "parent_email_#{n}@example.com" }
    sequence(:email_2)  {|n| "parent_email2_#{n}@example.com" }
    created_at Time.now
    updated_at Time.now
  end
end

