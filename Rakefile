# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

# Delayed Jobs Addition
begin
  require 'delayed/tasks'
rescue LoadError
  STDERR.puts "Run `bundle:install` to install delayed_job"
end

#Jammit and Jammit-s3 Addition
# require 'jammit'
# require 'jammit-s3'

ShelterExchangeApp::Application.load_tasks
