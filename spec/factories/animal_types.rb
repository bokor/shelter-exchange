FactoryGirl.define do

  factory :animal_type do
    sequence(:name) {|n| "type #{n}" }
  end
end

