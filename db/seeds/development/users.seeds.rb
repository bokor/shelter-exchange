# Truncate Data
#----------------------------------------------------------------------------
truncate_db_table("users")

after :"development:accounts" do

  # Create User
  #----------------------------------------------------------------------------
  account = Account.find_by_subdomain("brian")

  user = account.users.new(
    :name                  => "Brian Bokor",
    :role                  => User::OWNER,
    :title                 => "Lifesaver",
    :email                 => "brian.bokor@gmail.com",
    :password              => "testing",
    :password_confirmation => "testing"
  )
  user.save

  # Create User
  #----------------------------------------------------------------------------
  account = Account.find_by_subdomain("claire")

  user = account.users.new(
    :name                  => "Claire Bokor",
    :role                  => User::OWNER,
    :title                 => "Lifesaver",
    :email                 => "claire.bokor@gmail.com",
    :password              => "testing",
    :password_confirmation => "testing"
  )
  user.save
end

