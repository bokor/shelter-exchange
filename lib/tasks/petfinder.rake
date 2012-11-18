require 'csv'
require 'stringio'

PETFINDER_TASK_START_TIME    = Time.now
PETFINDER_SHELTER_START_TIME = 0
PETFINDER_LOG_FILENAME       = Rails.root.join("log/petfinder_rake_task.log")

Dir.mkdir(Rails.root.join("tmp/petfinder")) unless File.exists?(Rails.root.join("tmp/petfinder"))

# Tasks
#----------------------------------------------------------------------------
namespace :petfinder do
  
  desc "Creating Petfinder CSV files"
  task :generate_csv_files => :environment do
    
    @integrations = Integration::Petfinder.all
    
    @integrations.each do |integration|
      PETFINDER_SHELTER_START_TIME = Time.now
      
      @shelter = integration.shelter
    
      # Get all Available for adoption and Adoption Pending animals
      @animals = @shelter.animals.includes(:animal_type, :photos).available.all

      PETFINDER_CSV_FILENAME = Rails.root.join("tmp/petfinder/#{integration.username}.csv")
        
      # Build CSV
      CSV.open(PETFINDER_CSV_FILENAME, "w+") do |csv|
        Integration::PetfinderPresenter.as_csv(@animals, csv)
      end 
        
      # FTP Files to Adopt a Pet
      ftp_files_to_petfinder(@shelter.name, integration.username, integration.password, @animals)

      # Delete the CSV File
      File.delete(PETFINDER_CSV_FILENAME)
    end 
  end
  
  desc "Creating Petfinder CSV files"
  task :all => [:generate_csv_files] do 
    petfinder_logger.info("Time elapsed: #{Time.now - PETFINDER_TASK_START_TIME} seconds.")
    petfinder_logger.close
  end
  
end


# Local Methods
#----------------------------------------------------------------------------
def petfinder_logger
  @logger ||= Logger.new( File.open(PETFINDER_LOG_FILENAME, "w+") )
end

def ftp_files_to_petfinder(shelter_name, username, password, animals)
  begin
    Net::FTP.open(Integration::Petfinder::FTP_URL) do |ftp|
      ftp.login(username, password)
      ftp.passive = true
      # Upload CSV
      ftp.chdir('import')
      tp.puttextfile(PETFINDER_CSV_FILENAME)

      # Upload Photos
      ftp.chdir('photos')
      animals.each do |animal|
        animal.photos.limit(3).each_with_index do |photo, index|
          photo_url  = photo.image.url(:large)
          temp_image = StringIO.new(RestClient.get(photo_url))

          ftp.storbinary("STOR #{animal.id}-#{index+1}#{File.extname(photo_url)}", temp_image, 1024)
        end
      end
    end
    # Log Shelter name and how long it took for each shelter
    petfinder_logger.info("#{shelter_name} finished in #{Time.now - PETFINDER_SHELTER_START_TIME}")
  rescue Exception => e
    # Log Exception instead
    petfinder_logger.info("#{shelter_name} failed :: #{e}")
  end
end
