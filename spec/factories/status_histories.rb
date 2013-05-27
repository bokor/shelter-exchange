FactoryGirl.define do

  factory :status_history do
    shelter
    animal_status
    animal
    reason "New status history"
    created_at Time.now
    updated_at Time.now
  end
end

