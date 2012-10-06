require 'csv'

TASK_START_TIME = Time.now
SHELTER_START_TIME = 0
LOG_FILENAME = Rails.root.join("log/petfinder_rake_task.log")
CSV_FILENAME = "" #Rails.root.join("tmp/adopt_a_pet/pets.csv")

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
      @animals = @shelter.animals.includes(:animal_type, :photos).available.all

      # Setting the file name here as we need the shelter/integration id
      CSV_FILENAME = Rails.root.join("tmp/petfinder/pets.csv")
      
      # Build CSV
      CSV.open(CSV_FILENAME, "w+") do |csv|
        
        Integration::PetfinderPresenter.as_csv(@animals, csv)
        
      end 
      
      # FTP Files to Adopt a Pet
      ftp_files_to_petfinder(@shelter.name, integration.username, integration.password)
      
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

def ftp_files_to_petfinder(shelter_name, username, password)
  begin
    Net::FTP.open(Integration::Petfinder::FTP_URL) do |ftp|
      ftp.login(username, password)
      ftp.passive = true
      ftp.puttextfile(CSV_FILENAME)
    end
    # Log Shelter name and how long it took for each shelter
    logger.info("#{shelter_name} finished in #{Time.now - SHELTER_START_TIME}")
  rescue Exception => e
    # Log Exception instead
    logger.info("#{shelter_name} failed :: #{e}")
  end
end
