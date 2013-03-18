FactoryGirl.define do

  factory :comment do
    comment "This is a new comment"
    shelter
  end

end


  #create_table "comments", :force => true do |t|
    #t.text     "comment"
    #t.integer  "commentable_id"
    #t.string   "commentable_type"
    #t.datetime "created_at"
    #t.datetime "updated_at"
    #t.integer  "shelter_id"
  #end


