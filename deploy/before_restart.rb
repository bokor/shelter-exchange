# Install Jammit Gem
run "exec ssh-agent bash -c 'ssh-add /home/deploy/.ssh/shelter_exchange_app-deploy-key && git clone git://github.com/kmamykin/jammit-s3.git && cd jammit-s3 && git checkout -b remotes/origin/aws-s3 && gem build jammit-s3.gemspec && sudo gem install jammit-s3-0.6.0.2.gem'"

# Run Jammit-s3
run "cd #{current_path} && jammit-s3"

# Restart Delayed Job
# sudo "monit restart all -g dj_shelter_exchange_app"
sudo "/engineyard/bin/dj shelter_exchange_app start production"

# Upload Recipes
# Invoking Custom Chef Recipes
# To run your new recipe set you first need to upload the recipes to your environment.
# 
# From the root of your recipes repository run:
# 
# $ ey recipes upload -e <environment name>
# Then run them with:
# 
# $ ey recipes apply -e <environment name>
# You can also choose to do a full chef run:
# 
# $ ey rebuild -e <environment name>
# You can now deploy your app code that depends on customizations that chef has configured for you.


