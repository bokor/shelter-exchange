FactoryGirl.define do

  factory :user do
    sequence(:name) {|n| "SE User_#{n}" }
    title                 'Animal Lover'
    role                  'admin'
    sequence(:email) {|n| "user#{n}@example.com" }
    password              'password'
    password_confirmation 'password'
  end
end

