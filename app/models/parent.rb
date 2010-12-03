class Parent < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  # Associations
  has_many :placements, :dependent => :destroy
  # has_many :animals, :through => :parent_histories
  
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
  scope :search, lambda { |q| { :conditions => "LOWER(name) LIKE LOWER('%#{q}%') OR LOWER(street) LIKE LOWER('%#{q}%') 
                                                OR LOWER(home_phone) LIKE LOWER('%#{q}%') OR LOWER(mobile_phone) LIKE LOWER('%#{q}%') 
                                                OR LOWER(email) LIKE LOWER('%#{q}%')" }}
                                                
  
end
