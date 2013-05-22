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

