class StatusHistory < ActiveRecord::Base
  # Status History Namespaced
  include Reportable

  default_scope :order => 'created_at DESC'

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
  belongs_to :animal, :readonly => true
  belongs_to :animal_status, :readonly => true

  # Class Methods
  #----------------------------------------------------------------------------
  def self.create_with(shelter_id, animal_id, animal_status_id, reason)
    create!(:shelter_id => shelter_id, :animal_id => animal_id, :animal_status_id => animal_status_id, :reason => reason)
  end

end
