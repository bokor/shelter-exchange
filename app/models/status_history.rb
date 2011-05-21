class StatusHistory < ActiveRecord::Base
  default_scope :order => 'created_at DESC'

  # Associations
  belongs_to :shelter, :readonly => true
  belongs_to :animal, :readonly => true
  belongs_to :animal_status, :readonly => true

end
