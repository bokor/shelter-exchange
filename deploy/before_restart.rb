# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime"

# Run Jammit-s3
config_file = (environment == "production" ? "config/assets.yml" : "config/assets_#{environment}.yml")
on_app_master(){ run "cd #{current_path} && bundle exec jammit-s3 --config #{config_file}" }

# Clear Temp Cache
# run "cd #{current_path} && RAILS_ENV=#{environment} bundle exec rake cache:clear"
