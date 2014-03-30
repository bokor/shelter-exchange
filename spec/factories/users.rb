FactoryGirl.define do

  factory :user do
    sequence(:name)  {|n| "SE User_#{n}" }
    sequence(:email) {|n| "user#{n}@example.com" }
    title                 "Animal Lover"
    role                  "owner"
    password              "password"
    password_confirmation "password"
  end
end

