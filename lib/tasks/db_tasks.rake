require 'open-uri'

namespace :db do
  namespace :data do

    desc 'Generate background jobs to export data into csv files and download file attachments and photos.'
    task :export => :environment do
      Shelter.all.each do |shelter|
        Delayed::Job.enqueue(DataExportJob.new(shelter.id))
      end
    end
  end
end

