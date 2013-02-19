require 'csv'

module ShelterExchange
  module Jobs
    class AdoptAPetJob < Struct.new(:shelter_id)

      def initialize
        @shelter = Shelter.find(shelter_id)
        @animals = @shelter.animals.includes(:animal_type, :photos).available.all

        @csv_filename    = Rails.root.join("tmp/adopt_a_pet/#{@shelter.id}/pets.csv")
        @config_filename = Rails.root.join("public/integrations/adopt_a_pet/import.cfg")

        # Create the tmp folder for csv files
        Dir.mkdir(Rails.root.join("tmp/adopt_a_pet")) unless File.exists?(Rails.root.join("tmp/adopt_a_pet"))
        Dir.mkdir(Rails.root.join("tmp/adopt_a_pet/#{@shelter.id}")) unless File.exists?(Rails.root.join("tmp/adopt_a_pet/#{@shelter.id}"))
      end

      def perform



        # Remove shelter folder
        #FileUtils.rm_rf(Rails.root.join("tmp/adopt_a_pet/#{@shelter.id}"))
      end

    end
  end
end




  desc "Creating Adopt a Pet CSV files"
  task :generate_csv_files => :environment do

    Integration::AdoptAPet.all.each do |integration|
      ADOPT_A_PET_SHELTER_START_TIME = Time.now

      @shelter = integration.shelter

      # Get all Available for adoption and Adoption Pending animals
      @animals = @shelter.animals.includes(:animal_type, :photos).available.all

      unless @animals.blank?
        # Build CSV
        CSV.open(ADOPT_A_PET_CSV_FILENAME, "w+:UTF-8") do |csv|
          Integration::AdoptAPetPresenter.as_csv(@animals, csv)
        end

        # FTP Files to Adopt a Pet
        ftp_files_to_adopt_a_pet(@shelter.name, integration.username, integration.password)

        # Delete the CSV File
        File.delete(ADOPT_A_PET_CSV_FILENAME)
      else
        adopt_a_pet_logger.info("#{@shelter.name} has 0 animals")
      end
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

