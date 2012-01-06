class Shelter < ActiveRecord::Base

  # Plugins
  #----------------------------------------------------------------------------
  acts_as_mappable

  # Callbacks
  #----------------------------------------------------------------------------
  before_validation :delete_logo?
  after_validation :revert_logo?
  before_save :geocode_address, :format_phone_numbers
  
  # Constants
  #----------------------------------------------------------------------------
  LOGO_TYPES = ["image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png"].freeze
  LOGO_SIZE = 4.megabytes
  LOGO_SIZE_IN_TEXT = "4 MB"
  
  # Getter/Setter
  #----------------------------------------------------------------------------  
  attr_accessor :delete_logo
  
  # Assocations
  #----------------------------------------------------------------------------
  belongs_to :account

  has_many :locations, :dependent => :destroy
  has_many :accommodations, :dependent => :destroy
  has_many :placements, :dependent => :destroy
  has_many :animals, :dependent => :destroy
  has_many :notes, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :alerts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :items, :dependent => :destroy
  has_many :capacities, :dependent => :destroy
  has_many :status_histories, :dependent => :destroy
  has_many :transfers, :dependent => :destroy
  
  has_attached_file :logo, :whiny => true, 
                           :default_url => "/images/default_:style_logo.jpg", 
                           :storage => :s3,
                           :s3_credentials => S3_CREDENTIALS,
                           :s3_headers => { 'Cache-Control' => 'max-age=31536000', 
                                            'Expires' => 1.year.from_now.httpdate }, # 1 year
                           :path => "/:class/:attachment/:id/:style/:basename.:extension",
                           :styles => { :small => ["250x150>", :jpg],
                                        :medium => ["350x250>", :jpg],
                                        :large => ["500x400>", :jpg], 
                                        :thumb => ["150x75>", :jpg] }
  # Callback - Paperclip
  #----------------------------------------------------------------------------
  before_post_process :logo_valid?

  # Nested Attributes
  #----------------------------------------------------------------------------  
  accepts_nested_attributes_for :items, :allow_destroy => true
   
  # Validations
  #----------------------------------------------------------------------------
  validates :name, :presence => true
  validates :phone, :presence => true
  validates :email, :presence => true,
                    :uniqueness => true, :allow_blank => true,
                    :format => {:with => EMAIL_FORMAT, :message => "format is incorrect"}
  validates :time_zone, :inclusion => { :in => ActiveSupport::TimeZone.us_zones.map { |z| z.name }, :message => "is not a valid US Time Zone" }
  validates :access_token, :uniqueness => true, :on => :generate_access_token!    
  validates :website, :facebook, :format => { :with => URL_FORMAT,  :message => "format is incorrect" },
                                           :allow_blank => true
  validates :twitter, :format => { :with => TWITTER_USERNAME_FORMAT,  :message => "format is incorrect. Example @shelterexchange" },
                      :allow_blank => true
        
  validate :address_valid?         

  # Validations - Paperclip
  #---------------------------------------------------------------------------- 
  validates_attachment_size :logo, :less_than => LOGO_SIZE, :message => "needs to be #{LOGO_SIZE_IN_TEXT} or less"
  validates_attachment_content_type :logo, :content_type => LOGO_TYPES, :message => "needs to be a JPG, PNG, or GIF file"
  
  
  # Scopes
  #----------------------------------------------------------------------------
  scope :auto_complete, lambda { |q|  where("LOWER(name) LIKE LOWER(?)", "%#{q}%") }
  scope :by_access_token, lambda { |access_token| where(:access_token => access_token) }
  scope :live_search, lambda { |q| where("name LIKE LOWER('%#{q}%') OR city LIKE LOWER('%#{q}%') OR 
                                          state LIKE LOWER('%#{q}%') OR zip_code LIKE LOWER('%#{q}%') OR 
                                          facebook LIKE LOWER('%#{q}%') OR email LIKE LOWER('%#{q}%')") }
  scope :kill_shelters, where(:is_kill_shelter => true).order(:name) 
  scope :no_kill_shelters, where(:is_kill_shelter => false).order(:name) 
  scope :latest, lambda {|limit| order("created_at desc").limit(limit) }

  
  # Instance Methods
  #----------------------------------------------------------------------------
  def generate_access_token!
    # self.access_token = ActiveSupport::SecureRandom.base64(10)
    self.access_token = ActiveSupport::SecureRandom.hex(15)
    save!
  end
  
  def address_changed?
    (self.new_record?) or (self.street_changed? or self.street_2_changed? or self.city_changed? or self.state_changed? or self.zip_code_changed?)
  end
  
  def kill_shelter?
    self.is_kill_shelter
  end
  
  def no_kill_shelter?
    !self.is_kill_shelter
  end
  
  private
    def geocode_address
      if address_changed?
        geo = Geokit::Geocoders::MultiGeocoder.geocode ([self.street, self.city, self.state, self.zip_code].join(" "))
        errors.add(:street, "Could not Geocode address") if !geo.success
        self.lat, self.lng = geo.lat, geo.lng if geo.success
      end
    end

    def format_phone_numbers
      self.phone = self.phone.gsub(/[^0-9]/, "") unless self.phone.blank?
      self.fax = self.fax.gsub(/[^0-9]/, "") unless self.fax.blank?
    end
    
    def address_valid?
      errors.add(:address, "Street, City, State and Zip code are all required") if self.street.blank? or self.city.blank? or self.state.blank? or self.zip_code.blank?
    end
        
    def logo_valid?
      LOGO_TYPES.include?(self.logo_content_type) and self.logo_file_size < LOGO_SIZE
    end
    
    def revert_logo?
      if self.errors.present? and self.logo.file? and self.logo_file_name_changed?
        self.logo.instance_write(:file_name, self.logo_file_name_was) 
        self.logo.instance_write(:file_size, self.logo_file_size_was) 
        self.logo.instance_write(:content_type, self.logo_content_type_was)
        errors.add(:upload_logo_again, "please re-upload the logo")
      end
    end
    
    def delete_logo?
      self.logo.clear if delete_logo == "1" && !self.logo_file_name_changed?
    end
  
end
      #unless delete_logo.to_i.zero?
      # %w(street city state zip_code).all? { |attr| self.send(attr).blank? }