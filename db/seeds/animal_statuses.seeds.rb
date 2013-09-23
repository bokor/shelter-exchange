# Truncate Data
#----------------------------------------------------------------------------
ActiveRecord::Base.connection.execute("TRUNCATE animal_statuses")

# Create Animal Statuses
#----------------------------------------------------------------------------
AnimalStatus.create([
  { :name => "Available for Adoption", :sort_order => 1 },
  { :name => "Adopted", :sort_order => 2 },
  { :name => "Foster Care", :sort_order => 4 },
  { :name => "New Intake", :sort_order => 5 },
  { :name => "In Transit", :sort_order => 6 },
  { :name => "Rescue Candidate", :sort_order => 7 },
  { :name => "Stray Intake", :sort_order => 8 },
  { :name => "On Hold - Behavioral", :sort_order => 9 },
  { :name => "On Hold - Medical", :sort_order => 10 },
  { :name => "On Hold - Bite", :sort_order => 11 },
  { :name => "On Hold - Custody", :sort_order => 12 },
  { :name => "Reclaimed", :sort_order => 13 },
  { :name => "Deceased", :sort_order => 14 },
  { :name => "Euthanized", :sort_order => 15 },
  { :name => "Transferred", :sort_order => 16 },
  { :name => "Adoption Pending", :sort_order => 3 }
])
