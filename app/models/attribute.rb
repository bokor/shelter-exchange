class Attribute

  # Animal Types
  #----------------------------------------------------------------------------
  TYPES = {
    1 => "Dog",
    2 => "Cat",
    3 => "Horse",
    4 => "Rabbit",
    5 => "Bird",
    6 => "Reptile",
    7 => "Other"
  }.freeze
  #----------------------------------------------------------------------------

  # Breeds by Animal Type id
  #----------------------------------------------------------------------------
  BREEDS = {
    1 => DOG_BREEDS,
    2 => CAT_BREEDS,
    3 => HORSE_BREEDS,
    4 => RABBIT_BREEDS,
    5 => BIRD_BREEDS,
    6 => REPTILE_BREEDS,
    7 => OTHER_BREEDS
  }.freeze
  #----------------------------------------------------------------------------

  # Animal Statuses
  #----------------------------------------------------------------------------
  STATUSES = {
    1 => "Available for Adoption",
    2 => "Adopted",
    16 => "Adoption Pending",
    3 => "Foster Care",
    4 => "New Intake",
    5 => "In Transit",
    6 => "Rescue Candidate",
    7 => "Stray Intake",
    8 => "On Hold - Behavioral",
    9 => "On Hold - Medical",
    10 => "On Hold - Bite",
    11 => "On Hold - Custody",
    12 => "Reclaimed",
    13 => "Deceased",
    14 => "Euthanized",
    15 => "Transferred"
  }.freeze

  CAPACITY = [1,4,5,6,7,8,9,10,11,16].freeze
  ACTIVE = [1,3,4,5,6,7,8,9,10,11,16].freeze
  NON_ACTIVE = [2,12,13,14,15].freeze
  AVAILABLE = [1,16].freeze
  EXTRA_STATUS_FILTERS = [
    ["All Active", :active],
    ["All Non-Active", :non_active]
  ].freeze
  #----------------------------------------------------------------------------
end

