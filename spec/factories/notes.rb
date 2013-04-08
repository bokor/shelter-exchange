FactoryGirl.define do

  factory :note do
    sequence(:title) {|n| "note title #{n}" }
    description "New Note description"
    category Note::CATEGORIES[0]
    shelter
  end
end

