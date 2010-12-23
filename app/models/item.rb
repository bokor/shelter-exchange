class Item < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
   
  # Associations
  belongs_to :shelter
   
  # Validations

  # Scopes
  
end
