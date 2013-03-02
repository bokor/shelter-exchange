class Accommodation < ActiveRecord::Base
  # Accommodation Namespaced
  include Searchable

  default_scope :order => 'name ASC'

  # Pagination
  #----------------------------------------------------------------------------
  self.per_page = 50

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
end
