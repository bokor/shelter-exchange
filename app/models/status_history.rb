class StatusHistory < ActiveRecord::Base

  # Associations
  belongs_to :shelter
  belongs_to :animal
  belongs_to :animal_status
  
  # Validations

end
