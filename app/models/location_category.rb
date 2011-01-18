class LocationCategory < ActiveRecord::Base
  default_scope :order => 'name ASC'
  
  # Associations
  belongs_to :shelter   #, :conditions => {:state => 'active'}
  
  has_many :locations
  
  # Validations
  validates_presence_of :name
   
  # Callbacks
  
  # Scopes

end
