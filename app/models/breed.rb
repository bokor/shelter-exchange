class Breed < ActiveRecord::Base
  # Shared
  include Typeable

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :animal_type, :readonly => true

  # Scopes
  #----------------------------------------------------------------------------
  scope :valid_for_animal, lambda { |breed, type|  where(:name => breed, :animal_type_id => type) }
  scope :auto_complete, lambda { |type, q|  where(:animal_type_id => type).where("name LIKE ?", "%#{q}%") }
end

