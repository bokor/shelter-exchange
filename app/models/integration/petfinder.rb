class Integration::Petfinder < Integration
  
  require 'net/ftp'
  
  # Constants
  #----------------------------------------------------------------------------  
  FTP_URL = "members.petfinder.com"
  
  # Validations
  #----------------------------------------------------------------------------
  validates :username, :presence => true, :uniqueness => {:message => "Already in use with another shelter's account"}
  validates :password, :presence => true
  validate :connection_successful?, :if => lambda { |integration| integration.errors.blank? }
  
  private
  
    def connection_successful?
      begin
        Net::FTP.open(FTP_URL) {|ftp| ftp.login(self.username, self.password) }
      rescue
        errors.add(:connection_failed, "Petfinder FTP Username and/or FTP Password is incorrect.  Please Try again!")
      end
    end

end
