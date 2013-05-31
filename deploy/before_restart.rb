puts "ENVIRONMENT :: #{environment}"
# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime"

# Restart Delayed Job
restart_delayed_jobs = "monit restart all -g dj_#{app}"

if environment == "production"
  on_utilities("background_jobs"){ sudo(restart_delayed_jobs) }
elsif environment == "staging"
  sudo(restart_delayed_jobs)
end

# Update Crontab from Whenever
if environment == "production"
  on_utilities("background_jobs"){
    run "cd #{current_path} && bundle exec whenever --update-crontab '#{app}_#{environment}'"
  }
end

# Clear Temp Cache
# run "cd #{current_path} && RAILS_ENV=#{environment} bundle exec rake cache:clear"

