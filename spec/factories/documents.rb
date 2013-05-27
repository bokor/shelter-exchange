# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    created_at Time.now
    updated_at Time.now
  end
end
