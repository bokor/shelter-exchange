# Truncate Data
#----------------------------------------------------------------------------
truncate_db_table("accounts")

# Create Account
#----------------------------------------------------------------------------
account = Account.new(
  :subdomain     => "brian",
  :document      => File.open(Rails.root.join("app/assets/images/shelterexchange_icon_128x128.png")),
  :document_type => Account::DOCUMENT_TYPE[0]
)
account.save(:validate => false)

# Create Account
#----------------------------------------------------------------------------
account = Account.new(
  :subdomain     => "claire",
  :document      => File.open(Rails.root.join("app/assets/images/shelterexchange_icon_128x128.png")),
  :document_type => Account::DOCUMENT_TYPE[1]
)
account.save(:validate => false)

