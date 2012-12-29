FactoryGirl.define do
  
  factory :user do
    name                  'Brian Bokor'
    title                 'Engineer'
    role                  'admin'
    sequence(:email) {|n| "user#{n}@example.com" }
        # email           'brian.bokor@shelterexchange.org'
    password              'password'
    password_confirmation 'password'
  end

end