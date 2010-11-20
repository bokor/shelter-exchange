class Shelter < ActiveRecord::Base
  acts_as_mappable
  before_validation :geocode_address
  
  # Associations
  belongs_to :account
  has_many :animals, :dependent => :destroy
  has_many :notes, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :alerts, :dependent => :destroy
   
  # Validations
  validates_presence_of :name
  validates_presence_of :street
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip_code

  # Scopes
  
  private
    def geocode_address
      geo = Geokit::Geocoders::MultiGeocoder.geocode ([street, city, state, zip_code].join(" "))
      errors.add(:street, "Could not Geocode address") if !geo.success
      self.lat, self.lng = geo.lat,geo.lng if geo.success
    end
  
end
