# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime"

# Update Crontab from Whenever
# if config.environment == "production"
#   on_utilities("background_jobs"){
    run "cd #{config.current_path} && bundle exec whenever --update-crontab '#{config.app}_#{config.environment}'"
  # }
# end

# Clear Temp Cache
# run "cd #{current_path} && RAILS_ENV=#{environment} bundle exec rake cache:clear"

