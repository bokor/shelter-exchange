# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime"

# Run Jammit-s3
run "RAILS_ASSET_ID=2011012005123"
config_file = (environment == "production") ? "config/assets.yml" : "config/assets_#{environment}.yml"
run "cd #{current_path} && bundle exec jammit-s3 --config #{config_file}"

# Restart Delayed Job
sudo "monit restart all dj_shelter_exchange_app"




