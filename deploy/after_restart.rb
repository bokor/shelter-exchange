# Restart Delayed Job
if environment == "production"
  on_utilities("background_jobs"){ sudo "monit -g dj_shelter_exchange_app restart all" }
elsif ["staging"].include?(environment)
  sudo "monit -g dj_shelter_exchange_app restart all"
end

# Ping Search Engines - Updated Sitemap.xml
# if environment == "production"
#   on_utilities("background_jobs"){ run "cd #{current_path} && bundle exec rake sitemap:ping" }
# end
