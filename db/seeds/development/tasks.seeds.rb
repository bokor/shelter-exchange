 #Truncate Data
#----------------------------------------------------------------------------
# ActiveRecord::Base.connection.execute("TRUNCATE tasks")

#after :"development:shelters" do

   #Create Tasks
  #----------------------------------------------------------------------------
  #account = Account.find_by_subdomain("brian")
  #shelter = account.shelters.first

  #shelter.tasks.create([
    #{ :animal_type_id => AnimalType::TYPES[:dog], :max_capacity => 25 },
    #{ :animal_type_id => AnimalType::TYPES[:cat], :max_capacity => 25 },
    #{ :animal_type_id => AnimalType::TYPES[:horse], :max_capacity => 25 },
    #{ :animal_type_id => AnimalType::TYPES[:rabbit], :max_capacity => 25 },
    #{ :animal_type_id => AnimalType::TYPES[:bird], :max_capacity => 25 },
    #{ :animal_type_id => AnimalType::TYPES[:reptile], :max_capacity => 25 },
    #{ :animal_type_id => AnimalType::TYPES[:other], :max_capacity => 25 }
  #])

   #Create Tasks
  #----------------------------------------------------------------------------
  #account = Account.find_by_subdomain("claire")
  #shelter = account.shelters.first

  #shelter.tasks.create([
    #{ :animal_type_id => AnimalType::TYPES[:dog], :max_capacity => 25 },
    #{ :animal_type_id => AnimalType::TYPES[:cat], :max_capacity => 25 },
    #{ :animal_type_id => AnimalType::TYPES[:horse], :max_capacity => 25 },
    #{ :animal_type_id => AnimalType::TYPES[:rabbit], :max_capacity => 25 },
    #{ :animal_type_id => AnimalType::TYPES[:bird], :max_capacity => 25 },
    #{ :animal_type_id => AnimalType::TYPES[:reptile], :max_capacity => 25 },
    #{ :animal_type_id => AnimalType::TYPES[:other], :max_capacity => 25 }
  #])
#end





 #create_table "tasks", :force => true do |t|
     #t.string   "details"
     #t.string   "due_at"
     #t.date     "due_date"
     #t.integer  "taskable_id"
     #t.string   "taskable_type"
     #t.string   "category"
     #t.datetime "created_at"
     #t.datetime "updated_at"
     #t.string   "due_category"
     #t.boolean  "completed",     :default => false, :null => false
     #t.integer  "shelter_id"
   #end
