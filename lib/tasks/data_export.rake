require 'open-uri'

namespace :data_export do
  desc 'Generate background jobs to export data into csv files and download file attachments and photos.'
  task :all => :environment do
    Shelter.all.each do |shelter|
      Delayed::Job.enqueue(DataExportJob.new(shelter.id))
    end
  end

  desc 'Removes old data export zip files.'
  task :clean => :environment do
    base_dir = File.join(Rails.root, "tmp", "data_export", "**")
    Dir.glob(base_dir).select do |file|
      if File.file?(file) && File.extname(file) == ".zip" && File.mtime(file) < (Time.now - (60*60))
        FileUtils.rm_rf file
      end
    end
  end
end

