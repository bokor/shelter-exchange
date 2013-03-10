require 'csv'

module ShelterExchange
  module Jobs
    class AdoptAPetJob < Struct.new(:shelter_id)

      def initialize
        @shelter         = Shelter.find(shelter_id)
        @integration     = Integration.where(:shelter => @shelter).where(:type => :adopt_a_pet).first
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

          ftp_files

          # Delete the CSV File
          File.delete(@csv_filename)
        end
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
        rescue  #Exception => e
        end
      end

    end
  end
end






