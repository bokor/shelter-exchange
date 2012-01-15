class Integration::AdoptAPet < Integration
  
  require 'net/ftp'
  
  # Callbacks
  #----------------------------------------------------------------------------  
  
  # Getter/Setter
  #----------------------------------------------------------------------------  

  # Constants
  #----------------------------------------------------------------------------  
  FTP_URL = "autoupload.adoptapet.com"
  
  # Validations
  #----------------------------------------------------------------------------
  validates :username, :presence => true
  validates :password, :presence => true
  validate :connection_successful?, :if => lambda { |integration| integration.errors.blank? }
  
  # Scopes
  #----------------------------------------------------------------------------

  # Class Methods
  #----------------------------------------------------------------------------
  
  # Instance Methods
  #----------------------------------------------------------------------------
  
  private
  
    def connection_successful?
      begin
        Net::FTP.new(FTP_URL, self.username, self.password)
      rescue
        errors.add(:connection_failed, "Adopt a Pet FTP Username and/or FTP Password is incorrect.  Please Try again!")
      end
    end

end

  # validates :type, :uniqueness => { :scope => :shelter_id, :message => "has already been created" }