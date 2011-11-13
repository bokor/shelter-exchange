# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime"

# Run Jammit-s3
config_file = (environment == "production" ? "config/assets.yml" : "config/assets_#{environment}.yml")
on_app_master(){ run "cd #{current_path} && bundle exec jammit-s3 --config #{config_file}" }


# if environment == "production"
#   on_app_master(){ run "cd #{current_path} && bundle exec jammit-s3 --config #{config_file}" }
# elsif ["staging"].include?(environment)
#   run "cd #{current_path} && bundle exec jammit-s3 --config #{config_file}"
# end







