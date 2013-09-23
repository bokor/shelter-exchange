# Truncate Data
#----------------------------------------------------------------------------
ActiveRecord::Base.connection.execute("TRUNCATE items")

after :"development:shelters" do

  # Create Items
  #----------------------------------------------------------------------------
  account = Account.find_by_subdomain("brian")
  shelter = account.shelters.first

  shelter.items.create([
    { :name => "Need Food" },
    { :name => "Money" },
    { :name => "Help with shelter" },
    { :name => "Poo Picker" },
    { :name => "Testing" }
  ])

  # Create Items
  #----------------------------------------------------------------------------
  account = Account.find_by_subdomain("claire")
  shelter = account.shelters.first

  shelter.items.create([
    { :name => "Need Food" },
    { :name => "Money" },
    { :name => "Help with shelter" },
    { :name => "Poo Picker" },
    { :name => "Testing" }
  ])
end


