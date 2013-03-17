# Truncate Data
#----------------------------------------------------------------------------
truncate_db_table("owners")

# Create Owner
#----------------------------------------------------------------------------
Owner.create(
  :name                  => "Brian Bokor",
  :email                 => "brian.bokor@gmail.com",
  :password              => "testing",
  :password_confirmation => "testing"
)

# Create Owner
#----------------------------------------------------------------------------
Owner.create(
  :name                  => "Claire Bokor",
  :email                 => "claire.bokor@gmail.com",
  :password              => "testing",
  :password_confirmation => "testing"
)

