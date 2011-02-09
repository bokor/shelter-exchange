class Location < ActiveRecord::Base
  default_scope :order => 'name ASC'
  
  # Associations
  belongs_to :shelter
  
  has_many :accommodations
  
  # Validations
  validates_presence_of :name
   
  # Callbacks
  
  # Scopes


end
