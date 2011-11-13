# Remove Jammit-S3 - Generated Assets
# sudo "rm -rf #{current_path}/public/assets/*"

# Restart Delayed Job
if environment == "production"
  on_utilities("shelter_exchange_util"){ sudo "monit -g dj_shelter_exchange_app restart all" }
elsif ["staging"].include?(environment)
  sudo "monit -g dj_shelter_exchange_app restart all"
end
