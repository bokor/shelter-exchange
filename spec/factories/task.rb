FactoryGirl.define do

  factory :task do
    details "This is a new task"
    due_at nil
    due_date Date.today
    category ""
    due_category "today"
    completed false
    shelter
  end
end

