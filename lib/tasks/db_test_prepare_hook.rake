namespace :db do
  namespace :test do
    task :prepare => :environment do
      Rails.env = "test"
      Rake::Task["db:seed"].invoke
    end
  end
end