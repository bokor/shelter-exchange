FactoryGirl.define do

  factory :status_history do
    shelter
    animal_status
    animal
    reason "New status history"
  end
end

