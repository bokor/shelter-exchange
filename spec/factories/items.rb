FactoryGirl.define do

  factory :item do
    name "Sample item"
    shelter
    created_at Time.now
    updated_at Time.now
  end
end

