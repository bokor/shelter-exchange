class Accommodation < ActiveRecord::Base
  default_scope :order => 'name ASC', :limit => 250
  
  # Rails.env.development? ? PER_PAGE = 4 : PER_PAGE = 50
  PER_PAGE = 50
  
  # Associations
  belongs_to :shelter
  belongs_to :animal_type
  belongs_to :location
  
  has_many :animals
  
  # Validations
  validates_presence_of :animal_type_id, :message => 'needs to be selected'
  validates_presence_of :name
  validates_numericality_of :max_capacity
   
  # Callbacks
  
  # Scopes
  scope :full_search, lambda { |q| includes(:animal_type, :animals, :location).where("LOWER(name) LIKE LOWER('%#{q}%')") }
  
  
end

#belongs_to :shelter   #, :conditions => {:state => 'active'}
#validates_numericality_of :max_capacity #, :on => :create, :message => "is not a number"
