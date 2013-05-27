# Stop Delayed Job
if environment == "production"
  on_utilities("background_jobs"){ run "sudo monit stop all -g dj_shelter_exchange_app" }
elsif ["staging"].include?(environment)
  run "sudo monit stop all -g dj_shelter_exchange_app"
end
