class Breed < ActiveRecord::Base
  # Shared
  include Typeable

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :animal_type, :readonly => true

  # Scopes
  #----------------------------------------------------------------------------
  scope :auto_complete, lambda { |type, q|  where(:animal_type_id => type).where("name LIKE ?", "%#{q}%") }
end
