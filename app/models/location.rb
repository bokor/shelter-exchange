class Location < ActiveRecord::Base
  default_scope :order => 'name ASC'

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true

  has_many :accommodations, :readonly => true

  # Validations
  #----------------------------------------------------------------------------
  validates :name, :presence => true
end
