class Parent < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  # Associations
  has_many :placements, :dependent => :destroy
  has_many :notes, :as => :notable, :dependent => :destroy
  
  # Validations
  validates_presence_of :name
  validates_presence_of :street
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip_code
  validates :home_phone, :presence => true, :uniqueness => true
  validates :mobile_phone, :uniqueness => true
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
                    
  # Scopes
  scope :search, lambda { |q| where("name LIKE '%#{q}%' OR street LIKE '%#{q}%' 
                                     OR home_phone LIKE '%#{q}%' OR mobile_phone LIKE '%#{q}%' 
                                     OR email LIKE '%#{q}%'") }
                                                
  
end
