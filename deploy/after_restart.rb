# Remove Jammit-S3 - Generated Assets  SEEMS TO CAUSE ISSUES WITH THE ?date not to be added on the urls
# on_app_master(){ sudo "rm -rf #{current_path}/public/assets/*" }

# Restart Delayed Job
if environment == "production"
  on_utilities("shelter_exchange_util"){ sudo "monit -g dj_shelter_exchange_app restart all" }
elsif ["staging"].include?(environment)
  sudo "monit -g dj_shelter_exchange_app restart all"
end
