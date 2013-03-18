# Truncate Data
#----------------------------------------------------------------------------
truncate_db_table("animal_types")

# Create Animal Statuses
#----------------------------------------------------------------------------
AnimalType.create([
  { :name => "Dog" },
  { :name => "Cat" },
  { :name => "Horse" },
  { :name => "Rabbit" },
  { :name => "Bird" },
  { :name => "Reptile" },
  { :name => "Other" }
])
