require "CSV"
namespace :adopt_a_pet do
  desc "Creating Adopt a Pet CSV files"
  task :generate_csv_files => :environment do
    # @shelters = Shelter.includes(:animals).all
    @shelter = Shelter.includes(:animals).first
    CSV.open("tmp/pets.csv", "wb") do |csv|
      csv << ["id", "name", "breed", "secondary breed"]
      @shelter.animals.each do |animal|
        csv << [animal.id, animal.name, animal.primary_breed, animal.secondary_breed]
        Rake::Task['adopt_a_pet:ftp_files'].invoke
      end
    end
    
  end
  
  desc "Creating Adopt a Pet CSV files"
  task :ftp_files => :environment do
    puts "FTPed file sucka"
    Rake::Task['adopt_a_pet:ftp_files'].reenable
  end
  
  desc "Creating Adopt a Pet CSV files"
  task :all => [:generate_csv_files] do
    puts "lets GO!"
  end
  
end

# 15 * * * * cd /data/my_app/current && /usr/bin/rake RAILS_ENV=production accounts:email_expiring
# Clear all files in tmp/
# rake tmp:clear
# Clear all files and directories in tmp/cache
# rake tmp:cache:clear
# Clear all files in tmp/sessions
# rake tmp:sessions:clear
# Clear all files in tmp/sockets
# rake tmp:sockets:clear
# Rake can also clear the sessions table if you’re using one:
# rake db:sessions:clear


# namespace :db do
#   desc "load user data from csv"
#   task :load_csv_data  => :environment do
#     require 'fastercsv'
#     
#     FasterCSV.foreach("lib/tasks/address.csv") do |row|
#       User.create(:last_name => row[0], :first_name => row[1], :address => row[2], :city => row[3], 
#       :state => row[4], :zip => row[5], :login => row[0], :email => row[1], :created_at => Time.now,
#       :updated_at => Time.now, :password => row[0])
#     end
#     
#   end
# end

# desc "Exports the database contents into CSV files."
# task :export => :environment do
#   require "FasterCSV"
#   require "FileUtils"
#  
#   path = File.join(DATASET_PATH, (ENV["DATASET"] || "."))
#  
#   FileUtils.mkdir_p(path)
#  
#   ActiveRecord::Base.establish_connection
#   database = ActiveRecord::Base.connection
#  
#   (database.tables - SKIP_TABLES).each do |table_name|
#     FasterCSV.open(File.join(path, "#{table_name}.csv"), "w") do |csv|
#       # Write column names
#       csv << database.columns(table_name).map(&:name)
#       # Write rows
#       database.select_rows("SELECT * FROM %s" % table_name).each { |row| csv << row }
#     end
#   end
# end


# require 'csv' 
# require 'net/ftp'
# 
# task :export_data => :environment do
#   path = "tmp/" 
#   filename = 'test_' + Date.today.to_s + '.dat' 
# 
#   messages = Message.where( :foo => bar) 
#   CSV.open(path + filename, "wb", :col_sep => '|') do |csv| 
# 
#     messages.each do |m| 
#       csv << [m.id.to_s, m.name] 
#       puts "Processing message " + m.id.to_s 
#     end 
#   end 
# 
#   puts "Uploading " + filename 
#   ftp = Net::FTP.new('ftp.hostname.com') 
#   ftp.login(user = "******", passwd = "*******") 
#   ftp.puttextfile(path + filename, filename) 
#   ftp.quit() 
# 
#   puts "Finished." 
# end