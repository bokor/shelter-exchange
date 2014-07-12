require "csv"
require "net/ftp"
require "stringio"

class PetfinderJob

  def initialize(shelter_id)
    @start_time = Time.now
    @shelter = Shelter.find(shelter_id)
    @integration = Integration::Petfinder.where(:shelter_id => shelter_id).first
  end

  def perform
    ftp = Net::FTP.new(Integration::Petfinder::FTP_URL)

    # Login to server
    ftp.login(@integration.username, @integration.password)
    ftp.passive = true

    # Setup directory and filenames
    tmp_directory = File.join(Rails.root, "tmp", "petfinder", "#{@shelter.id}")
    FileUtils.mkdir_p(tmp_directory)
    csv_file = File.join(tmp_directory, "#{@integration.username}.csv")

    # Get Animals for Auto Upload CSV
    @animals = @shelter.animals.includes(:animal_type, :photos).available.all

    # Build CSV
    CSV.open(csv_file , "w+:UTF-8") do |csv|
      Integration::PetfinderPresenter.as_csv(@animals, csv)
    end

    # Upload Files
    ftp.chdir("import")
    ftp.puttextfile(csv_file)

    # Upload Photos
    ftp.chdir("photos")
    @animals.each do |animal|
      animal.photos.take(3).each_with_index do |photo, index|
        photo_url  = photo.image.url(:large)
        uri = URI(photo_url)
        temp_image = StringIO.new(Net::HTTP.get(uri))

        ftp.storbinary("STOR #{animal.id}-#{index+1}#{File.extname(photo_url)}", temp_image, 1024)
      end
    end

  rescue Net::FTPPermError => e
    PetfinderJob.logger.error("#{@shelter.id} :: #{@shelter.name} :: failed :: #{e.message}")
  ensure
    ftp.close
    PetfinderJob.logger.info("#{@shelter.id} :: #{@shelter.name} :: finished in #{Time.now - @start_time}")
  end

  def self.logger
    @logger ||= begin
      case ENV["RAILS_ENV"] || ENV["RAKE_ENV"]
      when "test"
        Logger.new(nil)
      when "development"
        Logger.new($stdout)
      else
        Logger.new(File.join(Rails.root, "log", "petfinder_integration.log"))
      end
    end
  end
end

