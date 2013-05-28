namespace :clear do

  desc 'Clear Dalli Memcache Store'
  task :cache => :environment do
    Rails.cache.clear
  end

  desc 'Clear Carrierwave cached files'
  task :carrierwave => :environment do
    CarrierWave.clean_cached_files!
  end

end
