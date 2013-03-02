FactoryGirl.define do

  factory :placement do
    shelter
  end

end

#TODO: Need to create a note for each category using the correct shorthand

  # create_table "placements", :force => true do |t|
  #   t.integer  "animal_id"
  #   t.integer  "parent_id"
  #   t.integer  "shelter_id"
  #   t.string   "status"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  # end


  # Validations
  #----------------------------------------------------------------------------
  # validates :animal_id, :presence => {:message => 'needs to be selected'}
  # validates :status, :presence => {:in => STATUS, :message => 'needs to be selected'}


