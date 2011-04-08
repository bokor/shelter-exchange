class StatusHistory < ActiveRecord::Base
  default_scope :order => 'created_at DESC'

  # Associations
  belongs_to :shelter
  belongs_to :animal
  belongs_to :animal_status

end
