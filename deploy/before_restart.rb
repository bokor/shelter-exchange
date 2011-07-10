# Install Jammit Gem
run "exec ssh-agent bash -c 'ssh-add /home/deploy/.ssh/shelter_exchange_app-deploy-key && git clone clone git://github.com/kmamykin/jammit-s3.git #{current_path}/tmp/jammit-s3 && git checkout -b aws-s3 remotes/origin/aws-s3 #{current_path}/tmp/jammit-s3'"
run "cd #{current_path}/tmp/jammit-s3"
run "gem build jammit-s3.gemspec"
run "sudo gem install jammit-s3-0.6.0.2.gem"

# Run Jammit-s3
run "cd #{current_path} && jammit-s3"

# Upload Recipes
# run "ey recipes upload -e #{Rails.env}"
