class Accommodation < ActiveRecord::Base
  default_scope :order => 'name ASC', :limit => 250
  
  # Constants
  #----------------------------------------------------------------------------
  PER_PAGE = 50
  
  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
  belongs_to :animal_type, :readonly => true
  belongs_to :location, :readonly => true

  has_many :animals, :readonly => true
  
  # Validations
  #----------------------------------------------------------------------------
  validates :animal_type_id, :presence => {:message => "needs to be selected"}
  validates :name, :presence => true
  validates :max_capacity, :numericality => true
  
  # Scopes
  #----------------------------------------------------------------------------
  scope :search, lambda { |q| includes(:animal_type, :animals, :location).where("LOWER(name) LIKE LOWER('%#{q}%')") }
  
  
end