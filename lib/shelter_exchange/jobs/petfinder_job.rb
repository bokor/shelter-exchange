require 'csv'
require 'stringio'

module ShelterExchange
  module Jobs
    class PetfinderJob

      def initialize(shelter_id)
        @start_time   = Time.now
        @shelter      = Shelter.find(shelter_id)
        @integration  = Integration::Petfinder.where(:shelter_id => @shelter).first
        @animals      = @shelter.animals.includes(:animal_type, :photos).available.all
        @csv_filename = Rails.root.join("tmp/petfinder/#{@shelter.id}/#{@integration.username}.csv")

        # Create the tmp folder for csv files
        Dir.mkdir(Rails.root.join("tmp/petfinder")) unless File.exists?(Rails.root.join("tmp/petfinder"))
        Dir.mkdir(Rails.root.join("tmp/petfinder/#{@shelter.id}")) unless File.exists?(Rails.root.join("tmp/petfinder/#{@shelter.id}"))
      end

      def perform
        unless @animals.blank?
          # Build CSV
          CSV.open(@csv_filename , "w+:UTF-8") do |csv|
            Integration::PetfinderPresenter.as_csv(@animals, csv)
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
          Net::FTP.open(Integration::Petfinder::FTP_URL) do |ftp|
            ftp.login(@integration.username, @integration.password)
            ftp.passive = true
            # Upload CSV
            ftp.chdir('import')
            ftp.puttextfile(@csv_filename)

            # Upload Photos
            ftp.chdir('photos')
            @animals.each do |animal|
              animal.photos.limit(3).each_with_index do |photo, index|
                photo_url  = photo.image.url(:large)
                temp_image = StringIO.new(RestClient.get(photo_url))

                ftp.storbinary("STOR #{animal.id}-#{index+1}#{File.extname(photo_url)}", temp_image, 1024)
              end
            end
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

