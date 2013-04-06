FactoryGirl.define do

  factory :capacity do
    shelter
    animal_type_id AnimalType::TYPES[:dog]
    max_capacity 10
  end
end


  #create_table "capacities", :force => true do |t|
    #t.integer  "shelter_id"
    #t.integer  "animal_type_id"
    #t.integer  "max_capacity"
    #t.datetime "created_at"
    #t.datetime "updated_at"
  #end
