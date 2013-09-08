FactoryGirl.define do

  factory :owner do
    sequence(:name)  {|n| "SE Owner_#{n}" }
    sequence(:email) {|n| "user#{n}@example.com" }
    password              "password"
    password_confirmation "password"
  end
end

