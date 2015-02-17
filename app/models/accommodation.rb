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

  # Searching
  #----------------------------------------------------------------------------
  def self.search_and_filter(query, type_id, location_id, order_by)
    scope = self.scoped
    scope = scope.includes(:animal_type, :location, :animals => [:photos, :animal_status])

    # Filter by type
    scope = scope.where(:animal_type_id => type_id) unless type_id.blank?

    # Filter by location
    scope = scope.where(:location_id => location_id) unless location_id.blank?

    # Search by query
    unless query.blank?
      query = query.strip.split.join("%")
      scope = scope.where("accommodations.name LIKE ?", "%#{query}%")
    end

    # Order by
    scope = scope.reorder(order_by) unless order_by.blank?
    scope
  end
end

