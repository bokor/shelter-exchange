FactoryGirl.define do

  factory :animal_type do
    sequence(:name) {|n| "type #{n}" }
    created_at Time.now
    updated_at Time.now
  end
end

