FactoryGirl.define do

  factory :placement do
    animal
    parent
    shelter
    status Placement::STATUS[0]
    created_at Time.now
    updated_at Time.now
  end
end

