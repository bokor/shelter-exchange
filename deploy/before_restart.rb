# Install Jammit Gem
# run "cd #{current_path}/tmp/"
# run "exec ssh-agent bash -c 'ssh-add /home/deploy/.ssh/shelter_exchange_app-deploy-key && git clone git://github.com/kmamykin/jammit-s3.git'"
# run "cd jammit-s3"
# run "exec ssh-agent bash -c 'ssh-add /home/deploy/.ssh/shelter_exchange_app-deploy-key && git checkout -b remotes/origin/aws-s3'"
# run "gem build jammit-s3.gemspec"
# run "sudo gem install jammit-s3-0.6.0.2.gem"
run "cd"
run "git clone git://github.com/kmamykin/jammit-s3.git && cd jammit-s3"
run "git checkout -b remotes/origin/aws-s3"
run "gem build jammit-s3.gemspec"
run "sudo gem install jammit-s3-0.6.0.2.gem"

# Run Jammit-s3
run "cd #{current_path} && jammit-s3"

# Upload Recipes
# run "ey recipes upload -e #{Rails.env}"
