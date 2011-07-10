# Install Jammit Gem
run "git clone git://github.com/kmamykin/jammit-s3.git"
run "cd jammit-s3"
run "git checkout -b aws-s3 remotes/origin/aws-s3 && gem build jammit-s3.gemspec && sudo gem install jammit-s3-0.6.0.2.gem"

# Run Jammit-s3
run "cd #{current_path} && jammit-s3"

# Upload Recipes
# run "ey recipes upload -e #{Rails.env}"
