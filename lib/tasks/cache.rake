namespace :cache do
  desc 'Clear Dalli Memcache Store'
  task :clear => :environment do
    Rails.cache.clear
  end
end