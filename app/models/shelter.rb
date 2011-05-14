class Shelter < ActiveRecord::Base
  acts_as_mappable

  after_validation :logo_reverted?
  before_save :geocode_address, :format_phone_numbers
  
  
  # Associations
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
                           :default_url => "/images/default_:style_photo.jpg", 
                           :storage => :s3,
                           :s3_credentials => S3_CREDENTIALS,
                           :path => "/:class/:attachment/:id/:style/:basename.:extension",
                           :styles => { :small => ["250x150>", :jpg],
                                        :medium => ["350x250>", :jpg],
                                        :large => ["500x400>", :jpg], 
                                        :thumb => ["150x75>", :jpg] }
                          #:convert_options => { :small => "-quality 80", }
  before_post_process :logo_valid?
  accepts_nested_attributes_for :items, :allow_destroy => true
   
  # Validations
  validates :name, :presence => true
  validate :address_valid?
  validates :phone, :presence => true
  validates :email, :presence => true,
                    :uniqueness => true, :allow_blank => true,
                    :length => {:minimum => 3, :maximum => 254}, 
                    :format => {:with => EMAIL_FORMAT, :message => "format is incorrect"}
  validates :time_zone, :inclusion => { :in => ActiveSupport::TimeZone.us_zones.map { |z| z.name }, 
                                        :message => "is not a valid US Time Zone" }
  validates :access_token, :uniqueness => true, :on => :generate_access_token!                 
 
  validates_attachment_size :logo, :less_than => IMAGE_SIZE, :message => "needs to be 4 MB or less"
  validates_attachment_content_type :logo, :content_type => IMAGE_TYPES, :message => "needs to be a JPG, PNG, or GIF file"
  
  # Scopes  
  scope :auto_complete, lambda { |q|  where("LOWER(name) LIKE LOWER(?)", "%#{q}%") }
  scope :by_access_token, lambda { |access_token| where(:access_token => access_token) }
  
  def generate_access_token!
    # self.access_token = ActiveSupport::SecureRandom.base64(10)
    self.access_token = ActiveSupport::SecureRandom.hex(15)
    self.save
  end
  
  private
    def geocode_address
      if (self.new_record?) or (self.street_changed? or self.city_changed? or self.state_changed? or self.zip_code_changed?)
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
      logo? and logo_file_size < IMAGE_SIZE
    end
    
    def logo?
      IMAGE_TYPES.include?(logo_content_type)
    end
    
    def logo_reverted?
      unless self.errors[:logo_file_size].blank? or self.errors[:logo_content_type].blank?
        self.logo.instance_write(:file_name, self.logo_file_name_was) 
        self.logo.instance_write(:file_size, self.logo_file_size_was) 
        self.logo.instance_write(:content_type, self.logo_content_type_was)
      end
    end
  
end

