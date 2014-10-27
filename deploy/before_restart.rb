# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime"

# Update Crontab from Whenever
if config.environment == "production"
  on_app_master do
    run "cd #{config.release_path} && " +
        "bundle exec whenever --set environment=#{config.framework_env} --update-crontab '#{config.app}_#{config.framework_env}'"
  end
end

# Clear Temp Cache
# run "cd #{current_path} && RAILS_ENV=#{environment} bundle exec rake cache:clear"

