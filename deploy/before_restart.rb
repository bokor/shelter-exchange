# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime"

# Run Jammit-s3
config_file = (environment == "production") ? "config/assets.yml" : "config/assets_#{environment}.yml"
run "cd #{current_path} && RAILS_ASSET_ID=20110120051234 && bundle exec jammit-s3 --config #{config_file}"

# Restart Delayed Job
sudo "monit restart all dj_shelter_exchange_app"




