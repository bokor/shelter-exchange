class Location < ActiveRecord::Base
  default_scope :order => 'name ASC'
  
  # Associations
  belongs_to :shelter

  has_many :accommodations
  
  # Validations
  validates :name, :presence => true

end
