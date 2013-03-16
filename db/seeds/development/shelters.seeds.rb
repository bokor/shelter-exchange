# Truncate Data
#----------------------------------------------------------------------------
truncate_db_table("shelters")

after :"development:accounts" do

  # Create Shelter
  #----------------------------------------------------------------------------
  account = Account.find_by_subdomain("brian")

  shelter = account.shelters.new(
    :name => "Brian's Buddies",
    :phone => "999-999-9999",
    :fax => "999-999-9999",
    :website => "http://www.brianbokor.com",
    :twitter => "@brianbokor",
    :street => "730 Bair Island Rd",
    :street_2 => "Apt 101",
    :city => "Redwood City",
    :state => "CA",
    :zip_code => "94063",
    :is_kill_shelter => false,
    :email => "brian.bokor@shelterexchange.org",
    :time_zone => "Pacific Time (US & Canada)",
    :facebook => "http://www.facebook.com/brian.bokor",
    :logo => nil
  )
  shelter.save(:validate => false)

  # Create Shelter
  #----------------------------------------------------------------------------
  account = Account.find_by_subdomain("claire")

  shelter = account.shelters.new(
    :name => "Claire's Buddies",
    :phone => "999-999-9999",
    :fax => "999-999-9999",
    :website => "http://www.clairebokor.com",
    :twitter => "@clairebokor",
    :street => "7333 Newport Ave",
    :city => "Raleigh",
    :state => "NC",
    :zip_code => "27613",
    :is_kill_shelter => false,
    :email => "claire.bokor@shelterexchange.org",
    :time_zone => "Eastern Time (US & Canada)",
    :facebook => "http://www.facebook.com/claire.bokor",
    :logo => nil
  )
  shelter.save(:validate => false)
end

