FactoryGirl.define do

  factory :task do
    details "This is a new task"
    due_at nil
    due_date Date.today
    category ""
    due_category "today"
    completed false
    shelter
    created_at Time.now
    updated_at Time.now
  end
end

