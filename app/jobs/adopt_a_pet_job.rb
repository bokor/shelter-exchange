require "csv"

class AdoptAPetJob

  def initialize(shelter_id)
    @start_time = Time.now
    @shelter = Shelter.find(shelter_id)
    @integration = Integration::AdoptAPet.where(:shelter => @shelter).first
  end

  def perform
    ftp = Net::FTP.new(Integration::AdoptAPet::FTP_URL)

    # Login to server
    ftp.login(@integration.username, @integration.password)
    ftp.passive = true

    # Setup directory and filenames
    tmp_directory = File.join(Rails.root, "tmp", "adopt_a_pet", "#{@shelter.id}")
    FileUtils.mkdir_p(tmp_directory)
    csv_file = File.join(tmp_directory, "pets.csv")
    import_file = Rails.application.assets.find_asset("integrations/adopt_a_pet/import.cfg")

    # Get Animals for Auto Upload CSV
    @animals = @shelter.animals.includes(:animal_type, :photos).available.all

    # Build CSV
    CSV.open(csv_file , "w+:UTF-8") do |csv|
      Integration::AdoptAPetPresenter.as_csv(@animals, csv)
    end

    # Upload Files
    ftp.puttextfile(csv_file)
    ftp.puttextfile(import_file)

  rescue Net::FTPPermError => e
    AdoptAPetJob.logger.info("#{@shelter.id} :: #{@shelter.name} :: failed :: #{e.message}")

    # FTP Error: 530 Login authentication failed
    if ftp.last_response_code == "530"
      # send emails
      # send email to shelter and users
      # disable integration
    end

  ensure
    ftp.close
    AdoptAPetJob.logger.info("#{@shelter.id} :: #{@shelter.name} :: finished in #{Time.now - @start_time}")
  end

  def self.logger
    @logger ||= begin
      case ENV["RAILS_ENV"] || ENV["RAKE_ENV"]
      when "test"
        Logger.new(nil)
      when "development"
        Logger.new($stdout)
      else
        Logger.new(File.join(Rails.root, "log", "adopt_a_pet_integration.log"))
      end
    end
  end
end

