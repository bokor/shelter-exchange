FactoryGirl.define do

  factory :task do
    details "This is a new task"
    additional_info nil
    due_at nil
    due_date Date.today
    category ""
    due_category "today"
    completed false
    shelter
  end
end

