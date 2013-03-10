FactoryGirl.define do

  factory :status_history do
    shelter
    animal
    animal_status
    reason "New status history"
  end

end

#   create_table "status_histories", :force => true do |t|
#     t.integer  "shelter_id"
#     t.integer  "animal_id"
#     t.integer  "animal_status_id"
#     t.string   "reason"
#     t.datetime "created_at"
#     t.datetime "updated_at"
#   end

