# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime"

# Run Jammit-s3
config_file = (environment == "production") ? "config/assets.yml" : "config/assets_#{environment}.yml"
run "cd #{current_path} && bundle exec jammit-s3 --config #{config_file}"

# Restart Delayed Job
sudo "monit restart all dj_shelter_exchange_app"
# sudo "monit -g dj_shelter_exchange_app restart all" OLD WAY

# run "cd #{current_path} && script/delayed_job restart"
# $ RAILS_ENV=production script/delayed_job start
# $ RAILS_ENV=production script/delayed_job stop
# # Runs two workers in separate processes.
# $ RAILS_ENV=production script/delayed_job -n 2 start
# $ RAILS_ENV=production script/delayed_job stop



