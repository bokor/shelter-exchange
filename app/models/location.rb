class Location < ActiveRecord::Base
  default_scope :order => 'name ASC'
  acts_as_taggable
  
  # Associations
  belongs_to :shelter   #, :conditions => {:state => 'active'}
  belongs_to :animal_type
  
  has_many :animals
  
  # Validations
  validates_presence_of :name
  validates_presence_of :animal_type_id, :message => 'needs to be selected'
  validates_numericality_of :max_capacity #, :on => :create, :message => "is not a number"
   
  # Callbacks
  
  # Scopes
  
end
