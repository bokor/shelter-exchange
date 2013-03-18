# Truncate Data
#----------------------------------------------------------------------------
truncate_db_table("accounts")

# Create Account
#----------------------------------------------------------------------------
account = Account.new(
  :subdomain     => "brian",
  :document      => File.open(Rails.root.join("public/shelterexchange_icon.png")),
  :document_type => Account::DOCUMENT_TYPE[0]
)
account.save(:validate => false)

# Create Account
#----------------------------------------------------------------------------
account = Account.new(
  :subdomain     => "claire",
  :document      => File.open(Rails.root.join("public/shelterexchange_icon.png")),
  :document_type => Account::DOCUMENT_TYPE[1]
)
account.save(:validate => false)

