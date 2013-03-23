require 'csv'

module ShelterExchange
  module Jobs
    class AdoptAPetJob

      def initialize(shelter_id)
        @start_time      = Time.now
        @shelter         = Shelter.find(shelter_id)
        @integration     = Integration::AdoptAPet.where(:shelter_id => @shelter).first
        @animals         = @shelter.animals.includes(:animal_type, :photos).available.all
        @csv_filename    = Rails.root.join("tmp/adopt_a_pet/#{@shelter.id}/pets.csv")
        @config_filename = Rails.root.join("public/integrations/adopt_a_pet/import.cfg")

        # Create the tmp folder for csv files
        Dir.mkdir(Rails.root.join("tmp/adopt_a_pet")) unless File.exists?(Rails.root.join("tmp/adopt_a_pet"))
        Dir.mkdir(Rails.root.join("tmp/adopt_a_pet/#{@shelter.id}")) unless File.exists?(Rails.root.join("tmp/adopt_a_pet/#{@shelter.id}"))
      end

      def perform
        unless @animals.blank?
          # Build CSV
          CSV.open(@csv_filename , "w+:UTF-8") do |csv|
            Integration::AdoptAPetPresenter.as_csv(@animals, csv)
          end

          #ftp files to server
          ftp_files

          # Delete the CSV File
          File.delete(@csv_filename)
        else
          logger.info("#{@integration.class.humanize} :: #{@shelter.name} has 0 animals")
        end

        # Log Shelter name and how long it took for each shelter
        logger.info("#{@integration.class.humanize} :: #{@shelter.name} finished in #{Time.now - @start_time}")
      end

      private
      def ftp_files
        begin
          Net::FTP.open(Integration::AdoptAPet::FTP_URL) do |ftp|
            ftp.login(@integration.username, @integration.password)
            ftp.passive = true
            ftp.puttextfile(@csv_filename)
            ftp.puttextfile(@config_filename)
          end
        rescue Exception => e
          logger.info("#{@integration.class.humanize} :: #{@shelter.name} failed :: #{e}")
        end
      end

      def logger
        @logger ||= Logger.new(File.join(Rails.root, "log", "#{@integration.type.demodulize.underscore}_integration.log"))
      end
    end
  end
end

