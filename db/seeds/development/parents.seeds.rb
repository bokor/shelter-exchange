# Truncate Data
#----------------------------------------------------------------------------
ActiveRecord::Base.connection.execute("TRUNCATE parents")

# Create Parent
#----------------------------------------------------------------------------
Parent.create({
  :name     => "Brian Bokor",
  :street   => "730 Bair Island Rd.",
  :street_2 => "Apt 101",
  :city     => "Redwood City",
  :state    => "CA",
  :zip_code => "94063",
  :phone    => "650-362-4948",
  :mobile   => "919-539-3365",
  :email    => "brian.bokor@gmail.com",
  :email_2  => "brian.bokor@shelterexchange.org"
})

# Create Parent
#----------------------------------------------------------------------------
Parent.create({
  :name     => "Claire Bokor",
  :street   => "7333 Newport Ave",
  :street_2 => "",
  :city     => "Raleigh",
  :state    => "NC",
  :zip_code => "27613",
  :phone    => "919-227-3051",
  :mobile   => "919-649-8538",
  :email    => "claire.bokor@gmail.com",
  :email_2  => "claire.bokor@shelterexchange.org"
})

