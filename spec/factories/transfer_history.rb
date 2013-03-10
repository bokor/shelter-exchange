FactoryGirl.define do

  factory :transfer_history do
    status "This is a transfer history status"
    shelter
  end

end

#TODO: Need to create a note for each category using the correct shorthand

  # create_table "transfer_histories", :force => true do |t|
  #   t.integer  "shelter_id"
  #   t.integer  "transfer_id"
  #   t.string   "status"
  #   t.text     "reason"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  # end

