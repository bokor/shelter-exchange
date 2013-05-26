class Accommodation < ActiveRecord::Base

  default_scope :order => 'accommodations.name ASC'

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

  # Scopes
  #----------------------------------------------------------------------------
  scope :search, lambda { |q|
    includes(:animal_type, :location, :animals => [:photos, :animal_status]).
    where("name LIKE ?", "%#{q}%")
  }

  # Class Methods
  #----------------------------------------------------------------------------
  def filter_by_type_location(type, location)
    scope = self.scoped
    scope = scope.includes(:animal_type, :location, :animals => [:photos, :animal_status])
    scope = scope.where(:animal_type_id => type) unless type.blank?
    scope = scope.where(:location_id => location) unless location.blank?
    scope
  end
end

