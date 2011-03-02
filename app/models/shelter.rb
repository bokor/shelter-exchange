class Shelter < ActiveRecord::Base
  acts_as_mappable
  before_validation :format_phone_numbers
  before_save :destroy_logo?, :geocode_address 
  
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
  
 # has_one :address, :as => :addressable, :dependent => :destroy
  
  has_attached_file :logo, :whiny => false, #:default_url => "/images/default_:style_photo.jpg", 
                            :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
                            :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
                            :styles => { :small => ["250x150>", :jpg],
                                         :medium => ["350x250>", :jpg],
                                         :large => ["500x400>", :jpg], 
                                         :thumb => ["100x75>", :jpg] } 

    
  accepts_nested_attributes_for :items, :allow_destroy => true
   
  # Validations
  validates :name, :street, :city, :state, :zip_code, :main_phone, :presence => true
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => EMAIL_FORMAT}
  validates :time_zone, :inclusion => { :in => ActiveSupport::TimeZone.us_zones.map { |z| z.name }, 
                                        :message => "is not a valid US Time Zone" }
  validates :access_token, :uniqueness => true, :on => :generate_access_token!                 
                    
  validates_attachment_size :logo, :less_than => 1.megabytes, :message => 'needs to be 1 MB or smaller'
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif'], :message => 'needs to be a JPG, PNG, or GIF file'
  
  # Scopes  
  scope :by_access_token, lambda { |access_token| where(:access_token => access_token) }

  def logo_delete
    @logo_delete ||= "0"
  end

  def logo_delete=(value)
    @logo_delete = value
  end
  
  def generate_access_token!
    # self.access_token = ActiveSupport::SecureRandom.base64(15)
    self.access_token = ActiveSupport::SecureRandom.hex(15)
    self.save
  end
  
  
  private
    def geocode_address
      if self.street_changed? or self.city_changed? or self.state_changed? or self.zip_code_changed?
        geo = Geokit::Geocoders::MultiGeocoder.geocode ([street, city, state, zip_code].join(" "))
        errors.add(:street, "Could not Geocode address") if !geo.success
        self.lat, self.lng = geo.lat,geo.lng if geo.success
      end
    end
    
    def destroy_logo?
      self.logo.clear if @logo_delete == "1"
    end
    
    def format_phone_numbers
      self.main_phone = self.main_phone.gsub(/[^0-9]/, "") unless self.main_phone.blank?
      self.fax_phone = self.fax_phone.gsub(/[^0-9]/, "") unless self.fax_phone.blank?
    end
  
end

