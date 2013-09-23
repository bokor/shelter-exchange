# Truncate Data
#----------------------------------------------------------------------------
ActiveRecord::Base.connection.execute("TRUNCATE capacities")

after :animal_types, :"development:shelters" do

  # Create Capacity
  #----------------------------------------------------------------------------
  account = Account.find_by_subdomain("brian")
  shelter = account.shelters.first

  shelter.capacities.create([
    { :animal_type_id => AnimalType::TYPES[:dog], :max_capacity => 25 },
    { :animal_type_id => AnimalType::TYPES[:cat], :max_capacity => 25 },
    { :animal_type_id => AnimalType::TYPES[:horse], :max_capacity => 25 },
    { :animal_type_id => AnimalType::TYPES[:rabbit], :max_capacity => 25 },
    { :animal_type_id => AnimalType::TYPES[:bird], :max_capacity => 25 },
    { :animal_type_id => AnimalType::TYPES[:reptile], :max_capacity => 25 },
    { :animal_type_id => AnimalType::TYPES[:other], :max_capacity => 25 }
  ])

  # Create Capacity
  #----------------------------------------------------------------------------
  account = Account.find_by_subdomain("claire")
  shelter = account.shelters.first

  shelter.capacities.create([
    { :animal_type_id => AnimalType::TYPES[:dog], :max_capacity => 25 },
    { :animal_type_id => AnimalType::TYPES[:cat], :max_capacity => 25 },
    { :animal_type_id => AnimalType::TYPES[:horse], :max_capacity => 25 },
    { :animal_type_id => AnimalType::TYPES[:rabbit], :max_capacity => 25 },
    { :animal_type_id => AnimalType::TYPES[:bird], :max_capacity => 25 },
    { :animal_type_id => AnimalType::TYPES[:reptile], :max_capacity => 25 },
    { :animal_type_id => AnimalType::TYPES[:other], :max_capacity => 25 }
  ])
end

