require 'csv'

ADOPT_A_PET_TASK_START_TIME    = Time.now
ADOPT_A_PET_SHELTER_START_TIME = 0
ADOPT_A_PET_LOG_FILENAME       = Rails.root.join("log/adopt_a_pet_rake_task.log")
ADOPT_A_PET_CSV_FILENAME       = Rails.root.join("tmp/adopt_a_pet/pets.csv")
ADOPT_A_PET_CFG_FILENAME       = Rails.root.join("public/integrations/adopt_a_pet/import.cfg")

Dir.mkdir(Rails.root.join("tmp/adopt_a_pet")) unless File.exists?(Rails.root.join("tmp/adopt_a_pet"))

# Tasks
#----------------------------------------------------------------------------
namespace :adopt_a_pet do
  
  desc "Creating Adopt a Pet CSV files"
  task :generate_csv_files => :environment do
    
    @integrations = Integration::AdoptAPet.all
    
    @integrations.each do |integration|
      ADOPT_A_PET_SHELTER_START_TIME = Time.now
      
      @shelter = integration.shelter
      # Get all Available for adoption and Adoption Pending animals
      @animals = @shelter.animals.includes(:animal_type, :photos).available.all

      # Upload to Adopt a pet when the animals have actually been updated in the past 2 hours
      if @animals.collect(&:updated_at).first > 2.hours.ago
        # Build CSV
        CSV.open(ADOPT_A_PET_CSV_FILENAME, "w+") do |csv|
          Integration::AdoptAPetPresenter.as_csv(@animals, csv)
        end 
        
        # FTP Files to Adopt a Pet
        ftp_files_to_adopt_a_pet(@shelter.name, integration.username, integration.password)
      end

    else
      adopt_a_pet_logger.info("#{shelter_name} :: No animals updated!")
    end
  end
  
  desc "Creating Adopt a Pet CSV files"
  task :all => [:generate_csv_files] do 

    adopt_a_pet_logger.info("Time elapsed: #{Time.now - ADOPT_A_PET_TASK_START_TIME} seconds.")
    adopt_a_pet_logger.close

  end
end


# Local Methods
#----------------------------------------------------------------------------
def adopt_a_pet_logger
  @logger ||= Logger.new( File.open(ADOPT_A_PET_LOG_FILENAME, "w+") )
end

def ftp_files_to_adopt_a_pet(shelter_name, username, password)
  begin
    Net::FTP.open(Integration::AdoptAPet::FTP_URL) do |ftp|
      ftp.login(username, password)
      ftp.passive = true
      ftp.puttextfile(ADOPT_A_PET_CSV_FILENAME)
      ftp.puttextfile(ADOPT_A_PET_CFG_FILENAME)
    end
    # Log Shelter name and how long it took for each shelter
    adopt_a_pet_logger.info("#{shelter_name} finished in #{Time.now - ADOPT_A_PET_SHELTER_START_TIME}")
  rescue Exception => e
    # Log Exception instead
    adopt_a_pet_logger.info("#{shelter_name} failed :: #{e}")
  end
end
