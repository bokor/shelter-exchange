require 'csv'


# [18] pry(main)> ftp = Net::FTP.new(Integration::AdoptAPet::FTP_URL)
# #<Net::FTP:0x007fd197bb3eb8 @mon_owner=nil, @mon_count=0, @mon_mutex=#<Mutex:0x007fd197bb3e68>, @binary=true, @passive=false, @debug_mode=false, @resume=false, @sock=#<Net::FTP::BufferedSocket io=#<TCPSocket:0x007fd197bb3e18>>, @logged_in=false, @open_timeout=nil, @read_timeout=60, @last_response="220---------- Welcome to Pure-FTPd [privsep] [TLS] ----------\n220-You are user number 1 of 50 allowed.\n220-Local time is now 16:49. Server port: 21.\n220-This is a private system - No anonymous login\n220-IPv6 connections are also welcome on this server.\n220 You will be disconnected after 15 minutes of inactivity.\n", @last_response_code="220">
# [19] pry(main)> ftp.login("test","test")
# ftp.Net::FTPPermError: 530 Login authentication failed
# from /Users/bokor/.rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/net/ftp.rb:326:in `getresp'
# [20] pry(main)> ftp.last_response
# "530 Login authentication failed\n"
# [21] pry(main)> ftp.last_response_code



class AdoptAPetJob < Struct.new(:shelter_id)

  def perform
    @start_time      = Time.now
    @shelter         = Shelter.find(shelter_id)
    @integration     = Integration::AdoptAPet.where(:shelter_id => @shelter).first
    @animals         = @shelter.animals.includes(:animal_type, :photos).available.all
    @csv_filename    = Rails.root.join("tmp/adopt_a_pet/#{@shelter.id}/pets.csv")
    @config_filename = Rails.application.assets.find_asset("integrations/adopt_a_pet/import.cfg")

    # Create the tmp folder for csv files
    Dir.mkdir(Rails.root.join("tmp/adopt_a_pet")) unless File.exists?(Rails.root.join("tmp/adopt_a_pet"))
    Dir.mkdir(Rails.root.join("tmp/adopt_a_pet/#{@shelter.id}")) unless File.exists?(Rails.root.join("tmp/adopt_a_pet/#{@shelter.id}"))

    unless @animals.blank?
      # Build CSV
      CSV.open(@csv_filename , "w+:UTF-8") do |csv|
        Integration::AdoptAPetPresenter.as_csv(@animals, csv)
      end

      #ftp files to server
      ftp_files

      # Log Shelter name and how long it took for each shelter
      logger.info("#{@shelter.id} :: #{@shelter.name} :: finished in #{Time.now - @start_time}")
    else
      logger.info("#{@shelter.id} :: #{@shelter.name} :: has 0 animals")
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
    rescue Exception => e
      logger.info("#{@shelter.id} :: #{@shelter.name} :: failed :: #{e}")
    end
  end

  def logger
    @logger ||= Logger.new(File.join(Rails.root, "log", "#{@integration.type.demodulize.underscore}_integration.log"))
  end
end

