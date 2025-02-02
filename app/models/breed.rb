class Breed < ActiveRecord::Base
  include Typeable

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :animal_type, :readonly => true

  # Scopes
  #----------------------------------------------------------------------------
  scope :valid_for_animal, lambda { |breed, type|  where(:name => breed, :animal_type_id => type) }
end

