class Parent < ActiveRecord::Base
  default_scope :order => 'created_at DESC', :limit => 25
  
  # Associations
  has_many :placements, :dependent => :destroy
  has_many :notes, :as => :notable, :dependent => :destroy
  
  # Validations
  validates_presence_of :name
  validates_presence_of :street
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip_code
  validates :home_phone, :presence => true, 
                         :uniqueness => true
  validates :mobile_phone, :uniqueness => true
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => EMAIL_FORMAT}
                    
  # Scopes
  scope :search, lambda { |q| where("LOWER(name) LIKE LOWER('%#{q}%') OR LOWER(street) LIKE LOWER('%#{q}%') 
                                     OR LOWER(home_phone) LIKE LOWER('%#{q}%') OR LOWER(mobile_phone) LIKE LOWER('%#{q}%') 
                                     OR LOWER(email) LIKE LOWER('%#{q}%')") }
                                                
  
end
