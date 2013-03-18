FactoryGirl.define do

  factory :note do
    title "This is a new note"
    description "New Note description"
    category Note::CATEGORIES[0]
    shelter
  end
end

  #create_table "notes", :force => true do |t|
    #t.string   "title"
    #t.text     "description"
    #t.integer  "notable_id"
    #t.string   "notable_type"
    #t.datetime "created_at"
    #t.datetime "updated_at"
    #t.integer  "shelter_id"
    #t.string   "category"
  #end

