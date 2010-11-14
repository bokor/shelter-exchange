class Shelter < ActiveRecord::Base
  
  # Associations
   
  # Validations
  validates_presence_of :name
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip_code
   
  # Callbacks

  # Scopes
  
end
