FactoryGirl.define do

  factory :task do
    details "This is a new task"
    shelter
  end
end

  #create_table "tasks", :force => true do |t|
    #t.string   "details"
    #t.string   "due_at"
    #t.date     "due_date"
    #t.integer  "taskable_id"
    #t.string   "taskable_type"
    #t.string   "category"
    #t.string   "due_category"
    #t.boolean  "completed",     :default => false, :null => false
    #t.integer  "shelter_id"
  #end

