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

end
