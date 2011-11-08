# Remove Jammit-S3 - Generated Assets
sudo "rm -rf #{current_path}/public/assets/*"

# Restart Delayed Job
sudo "monit -g dj_shelter_exchange_app restart all"

# Ping Search Engines - Updated Sitemap.xml
# if environment == "production"
#   ping
# end