FactoryGirl.define do

  factory :transfer do
    requestor
    phone     "999-999-9999"
    email     "shelter@example.com"
  end
end


 #validates :requestor, :presence => true
 #validates :transfer_history_reason, :presence => { :if => :transfer_history_reason_required? }


#TODO: Need to create a note for each category using the correct shorthand

  # create_table "transfers", :force => true do |t|
  #   t.integer  "animal_id"
  #   t.integer  "requestor_shelter_id"
  #   t.string   "requestor"
  #   t.string   "phone"
  #   t.string   "email"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  #   t.integer  "shelter_id"
  #   t.string   "status"
  # end

