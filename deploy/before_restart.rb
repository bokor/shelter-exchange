# Set Current TimeZone
sudo "ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime"

# Run Jammit-s3
run "cd #{current_path} && bundle exec jammit-s3"

# Restart Delayed Job
sudo "monit -g dj_shelter_exchange_app restart all"



