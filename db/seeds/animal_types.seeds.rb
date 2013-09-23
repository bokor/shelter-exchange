# Truncate Data
#----------------------------------------------------------------------------
ActiveRecord::Base.connection.execute("TRUNCATE animal_types")

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
