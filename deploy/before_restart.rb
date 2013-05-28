# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime"

# Restart Delayed Job
if environment == "production"
  on_utilities("background_jobs"){ sudo "monit restart all -g dj_shelter_exchange_app" }
elsif ["staging"].include?(environment)
  sudo "monit restart all -g dj_shelter_exchange_app"
end

# Clear Temp Cache
# run "cd #{current_path} && RAILS_ENV=#{environment} bundle exec rake cache:clear"
