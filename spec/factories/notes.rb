FactoryGirl.define do

  factory :note do
    sequence(:title) {|n| "note title #{n}" }
    description "New Note description"
    category Note::CATEGORIES[0]
    hidden false
    shelter
    created_at Time.now
    updated_at Time.now
  end
end

