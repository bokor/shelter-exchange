require 'net/ftp'

class Integration::AdoptAPet < Integration

  # Constants
  #----------------------------------------------------------------------------
  FTP_URL = "autoupload.adoptapet.com"

  # Callbacks
  #----------------------------------------------------------------------------
  after_save :update_remote_animals

  # Validations
  #----------------------------------------------------------------------------
  validates :username, :presence => true, :uniqueness => {:message => "Already in use with another shelter's account"}
  validates :password, :presence => true
  validate :connection_successful?, :if => lambda { |integration| integration.errors.blank? }

  def self.model_name
    self.superclass.model_name
  end

  def humanize
    "Adopt a Pet"
  end

  def to_s
    "adopt_a_pet"
  end

  def to_sym
    :adopt_a_pet
  end


  #----------------------------------------------------------------------------
  private

  def connection_successful?
    begin
      Net::FTP.open(FTP_URL) {|ftp| ftp.login(self.username, self.password) }
    rescue
      errors.add(:connection_failed, "#{self.humanize} FTP Username and/or FTP Password is incorrect.  Please Try again!")
    end
  end

  def update_remote_animals
    Delayed::Job.enqueue(AdoptAPetJob.new(self.shelter_id))
  end
end

