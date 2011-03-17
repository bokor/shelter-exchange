class Accommodation < ActiveRecord::Base
  default_scope :order => 'name ASC', :limit => 250
  
  # Pagination - Per Page
  # Rails.env.development? ? PER_PAGE = 4 : PER_PAGE = 50
  PER_PAGE = 50
  
  # Associations
  belongs_to :shelter
  belongs_to :animal_type
  belongs_to :location

  has_many :animals
  
  # Validations
  validates :animal_type_id, :presence => {:message => "needs to be selected"}
  validates :name, :presence => true
  validates :max_capacity, :numericality => true
  
  # Scopes
  scope :search, lambda { |q| includes(:animal_type, :animals, :location).where("LOWER(name) LIKE LOWER('%#{q}%')") }
  
  
end