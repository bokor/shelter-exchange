 # Stick this in lib/tasks/assets.rake or similar
 #
 # A bug was introduced in rails in 7f1a666d causing the whole application cache
 # to be cleared everytime a precompile is run, but it is not neccesary and just
 # slows down precompiling.
 #
 # Secondary consequences are the clearing of the whole cache, which if using
 # the default file cache could cause an application level performance hit.
 #
 # This is already fixed in sprockets-rails for rails 4, but we patch here for
 # interim gains.
 #
 # If you're using rails pre-3.2 change "primary" to "digest" below.

  Rake::Task["assets:precompile:primary"].prerequisites.delete "tmp:cache:clear"
  Rake::Task["assets:precompile:nondigest"].prerequisites.delete "tmp:cache:clear"

#Rake::Task['assets:precompile'].enhance do
  #Rake::Task['assets:link_error_pages:all'].invoke
#end

#namespace :assets do
  #namespace :link_error_pages do

    #desc 'Soft Link HTML error pages'
    #task :all => ['assets:environment', 'tmp:cache:clear'] do
      #asset_path = Rails.public_path + Rails.application.config.assets.prefix
      #target     = Rails.public_path

      #['404.html', '410.html', '422.html', '500.html', '503.html', 'maintenance.html'].each do |error_page|
        #system("ln -sf #{asset_path}/#{error_page} #{target}/#{error_page}")
      #end
    #end
  #end
#end

