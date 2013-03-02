class AnimalType < ActiveRecord::Base

  # Constants
  #----------------------------------------------------------------------------
  TYPES = {
    :dog     => 1,
    :cat     => 2,
    :horse   => 3,
    :rabbit  => 4,
    :bird    => 5,
    :reptile => 6,
    :other   => 7
  }.freeze

  # Associations
  #----------------------------------------------------------------------------
  has_many :animals, :readonly => true
  has_many :breeds, :readonly => true
  has_many :accommodations, :readonly => true
  has_many :capacities, :readonly => true

  # Scopes
  #----------------------------------------------------------------------------

  #TODO :
  # 1) not sure if this scope is used anywhere and if not then we should remove it.
  scope :available_for_adoption_types, lambda { |shelter_id| joins(:animals).select("distinct animal_types.name").where("animals.shelter_id = ?", shelter_id).where("animals.animal_status_id" => AnimalStatus::STATUSES[:available_for_adoption]).order("animal_types.id") }
end
