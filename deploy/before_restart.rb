# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime"

# Run Jammit-s3
config_file = (environment == "production") ? "config/assets.yml" : "config/assets_#{environment}.yml"
run "cd #{current_path} && bundle exec jammit-s3 --config #{config_file}"

# Configure whenever crontab updates
# Update this with the correct information so when we deploy it will update the crontab
# run "cd #{current_path} && whenever --update-crontab 'shelter_exchange_app_production'" if environment == "production"





