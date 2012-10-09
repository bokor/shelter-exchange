require 'csv'
require 'stringio'

TASK_START_TIME = Time.now
SHELTER_START_TIME = 0
LOG_FILENAME = Rails.root.join("log/petfinder_rake_task.log")
CSV_FILENAME = ""

Dir.mkdir(Rails.root.join("tmp/petfinder")) unless File.exists?(Rails.root.join("tmp/petfinder"))

# Tasks
#----------------------------------------------------------------------------
namespace :petfinder do
  
  desc "Creating Petfinder CSV files"
  task :generate_csv_files => :environment do
    
    @integrations = Integration::Petfinder.all
    
    @integrations.each do |integration|
      SHELTER_START_TIME = Time.now
      
      @shelter = integration.shelter
      @animals = @shelter.animals.includes(:animal_type, :photos).available.all # Gets all Available and adoption pending

      #
      #
      #
      # If the animals.collect(:&updated_at) is not greater than 2 hours...exit out of the loop
      #
      #
      #
      #

      # Setting the file name here as we need the integration username
      CSV_FILENAME = Rails.root.join("tmp/petfinder/#{integration.username}.csv")
      
      # Build CSV
      CSV.open(CSV_FILENAME, "w+") do |csv|
        Integration::PetfinderPresenter.as_csv(@animals, csv)
      end 
      
      # FTP Files to Adopt a Pet
      ftp_files_to_petfinder(@shelter.name, integration.username, integration.password, @animals)
      
    end #Integrations Each
    
  end
  
  desc "Creating Petfinder CSV files"
  task :all => [:generate_csv_files] do 
    logger.info("Time elapsed: #{Time.now - TASK_START_TIME} seconds.")
    logger.close
  end
  
end


# Local Methods
#----------------------------------------------------------------------------
def logger
  @logger ||= Logger.new( File.open(LOG_FILENAME, "w+") )
end

def ftp_files_to_petfinder(shelter_name, username, password, animals)
  begin
    Net::FTP.open(Integration::Petfinder::FTP_URL) do |ftp|
      ftp.login(username, password)
      ftp.passive = true
      ftp.chdir('import')
      ftp.puttextfile(CSV_FILENAME)

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
    logger.info("#{shelter_name} finished in #{Time.now - SHELTER_START_TIME}")
  rescue Exception => e
    # Log Exception instead
    logger.info("#{shelter_name} failed :: #{e}")
  end
end
