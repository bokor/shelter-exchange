class Shelter < ActiveRecord::Base
  acts_as_mappable
  before_validation :geocode_address
  before_save :destroy_logo?
  
  # Associations
  belongs_to :account
  
  has_many :locations, :dependent => :destroy
  has_many :accommodations, :dependent => :destroy
  has_many :placements, :dependent => :destroy
  # has_many :parents, :through => :placements
  has_many :animals, :dependent => :destroy
  has_many :notes, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :alerts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :items, :dependent => :destroy
  has_many :capacities, :dependent => :destroy
  
  has_attached_file :logo, :whiny => false , #:default_url => "/images/default_:style_photo.jpg", 
                            :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
                            :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
                            :styles => { :small => ["250x150>", :jpg],
                                         :medium => ["350x250>", :jpg],
                                         :large => ["500x400>", :jpg], 
                                         :thumb => ["100x75>", :jpg] } 

    
  accepts_nested_attributes_for :items, :allow_destroy => true
   
  # Validations
  validates_presence_of :name
  validates_presence_of :street
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip_code
  validates_presence_of :main_phone
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
                    
  validates_attachment_size :logo, :less_than => 1.megabytes, :message => 'needs to be 1 MB or smaller'
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif'], :message => 'needs to be a JPG, PNG, or GIF file'
  
  # Scopes  

  def logo_delete
    @logo_delete ||= "0"
  end

  def logo_delete=(value)
    @logo_delete = value
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
  
end
