class Shelter < ActiveRecord::Base
  acts_as_mappable
  before_validation :geocode_address
  
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
  
  accepts_nested_attributes_for :items, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
   
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

  # Scopes
  
  private
    def geocode_address
      if self.street_changed? or self.city_changed? or self.state_changed? or self.zip_code_changed?
        geo = Geokit::Geocoders::MultiGeocoder.geocode ([street, city, state, zip_code].join(" "))
        errors.add(:street, "Could not Geocode address") if !geo.success
        self.lat, self.lng = geo.lat,geo.lng if geo.success
      end
    end
  
end
