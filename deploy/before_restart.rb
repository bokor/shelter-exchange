# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime"

# Run Jammit-s3
case environment
when "production"
  on_app_master(){ run "cd #{current_path} && bundle exec jammit-s3 --config config/assets.yml" }
when "staging"
  run "cd #{current_path} && bundle exec jammit-s3 --config config/assets_staging.yml"
end






