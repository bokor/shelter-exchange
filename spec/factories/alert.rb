FactoryGirl.define do

  factory :alert do
    title "This is a new alert"
    shelter
  end
end

  #create_table "alerts", :force => true do |t|
    #t.string   "title"
    #t.text     "description"
    #t.integer  "alertable_id"
    #t.string   "alertable_type"
    #t.datetime "created_at"
    #t.datetime "updated_at"
    #t.boolean  "stopped",        :default => false, :null => false
    #t.integer  "shelter_id"
    #t.string   "severity"
  #end


