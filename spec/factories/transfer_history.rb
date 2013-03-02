FactoryGirl.define do

  factory :note do
    title "This is a new note"
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

