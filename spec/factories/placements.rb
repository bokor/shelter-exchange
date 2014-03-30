FactoryGirl.define do

  factory :placement do
    animal
    parent
    shelter
    status Placement::STATUS[0]
  end
end

