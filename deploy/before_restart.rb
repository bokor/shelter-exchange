# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime"

# Run Jammit-s3
config_file = (environment == "production" ? "config/assets.yml" : "config/assets_#{environment}.yml")
on_app_master(){ run "cd #{current_path} && bundle exec jammit-s3 --config #{config_file}" }

# Restart Delayed Job
if environment == "production"
  on_utilities("background_jobs"){ sudo "monit restart all -g dj_shelter_exchange_app" }
elsif ["staging"].include?(environment)
  sudo "monit restart all -g dj_shelter_exchange_app"
end

# Clear Temp Cache
# run "cd #{current_path} && RAILS_ENV=#{environment} bundle exec rake cache:clear"
