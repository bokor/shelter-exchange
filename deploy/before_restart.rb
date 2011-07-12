# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Eastern /usr/share/zoneinfo/localtime"

# Remove Generated Assets
sudo "rm -rf #{current_path}/public/assets/*"

# Run Jammit-s3
run "cd #{current_path} && bundle exec jammit-s3"

# Restart Delayed Job
sudo "monit -g dj_shelter_exchange_app restart all"



