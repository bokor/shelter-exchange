FactoryGirl.define do

  factory :comment do
    comment "This is a new comment"
    shelter
    created_at Time.now
    updated_at Time.now
  end
end

