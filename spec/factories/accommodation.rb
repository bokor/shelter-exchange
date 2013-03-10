FactoryGirl.define do

  factory :accommodation do
    shelter
    animal_type
    sequence(:name) {|n| "crate#{n}" }
    max_capacity 10
  end

end


  #create_table "accommodations", :force => true do |t|
    #t.integer  "shelter_id"
    #t.integer  "animal_type_id"
    #t.string   "name"
    #t.integer  "max_capacity"
    #t.datetime "created_at"
    #t.datetime "updated_at"
    #t.integer  "location_id"
  #end
